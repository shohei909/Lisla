package litll.idl.library;

import haxe.ds.Option;
import haxe.io.Path;
import hxext.ds.Maybe;
import hxext.ds.Result;
import litll.idl.generator.error.ReadIdlError;
import litll.idl.generator.error.ReadIdlErrorKind;
import litll.idl.generator.source.IdlSourceReader;
import litll.idl.generator.source.file.IdlFilePath;
import litll.idl.generator.source.file.LoadedIdl;
import litll.idl.generator.source.validate.ValidType;
import litll.idl.library.PackageElement;
import litll.idl.litlltext2entity.LitllTextToEntityRunner;
import litll.idl.std.data.idl.LibraryName;
import litll.idl.std.data.idl.ModulePath;
import litll.idl.std.data.idl.PackagePath;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.library.LibraryConfig;
import litll.idl.std.litll2entity.idl.IdlLitllToEntity;

class Library extends PackageElement implements LibraryResolver
{
    // ========================
    // Parent
    // ========================
    private var series:LibrarySeries;
        
    // ========================
    // Children
    // ========================
    private var filePath:String;
    private var name:String;
    private var baseDirectory:String;
    private var config:LibraryConfig;
    
    // ========================
    // Dependency injection
    // ========================
    private var sourceReader:IdlSourceReader;
    
    // ========================
    // Getter
    // ========================
    private var scope(get, never):LibraryScope;
    private function get_scope():LibraryScope {
        return series.scope;
    }
    
    public function new(
        series:LibrarySeries,
        filePath:String, 
        name:String, 
        sourceReader:IdlSourceReader,
        config:LibraryConfig
    )
    {
        this.config = config;
        this.series = series;
        this.filePath = filePath;
        this.name = name;
        this.config = config;
        this.sourceReader = sourceReader;
        this.baseDirectory = Path.directory(filePath);
        
        super(this, new PackagePath([name]));
    }
    
    public function loadTypes():Result<Array<ValidType>, Array<ReadIdlError>>
    {
        var context:LoadTypesContext = new LoadTypesContext();
        var types:Array<ValidType> = [];
        
        fetchChildren(context, types);
        
        return if (context.errors.length > 0)
        {
            Result.Err(context.errors.toArray());
        }
        else
        {
            Result.Ok(types);
        }
    }
    
    public function loadType(modulePath:ModulePath, typeName:TypeName):Result<Maybe<ValidType>, Array<ReadIdlError>>
    {
        var context:LoadTypesContext = new LoadTypesContext();
        var element = switch getModuleElement(modulePath).toOption()
        {
            case Option.Some(_element):
                _element;
                
            case Option.None:
                return Result.Ok(Maybe.none());
        }
        
        var typeDefinition = element.getValidType(context, typeName);
        return if (context.errors.length > 0)
        {
            Result.Err(context.errors.toArray());
        }
        else
        {
            Result.Ok(typeDefinition);
        }
    }
    
    public function getModuleElement(modulePath:ModulePath):Maybe<PackageElement>
    {
        return getLocalElement(modulePath.toArray().slice(1));
    }
    
    // ========================
    // for Children
    // ========================
    public function moduleExistsAt(path:ModulePath):Bool
	{
        return sourceReader.moduleExists(baseDirectory, path);
	}
	
	public function directoryExistsAt(path:PackagePath):Bool
	{
        return sourceReader.directoryExists(baseDirectory, path);
	}
	
    public function getChildrenAt(path:PackagePath):Array<String>
    {
        return sourceReader.getChildren(baseDirectory, path);
    }
    
	public function readModuleAt(path:ModulePath):Result<Maybe<LoadedIdl>, Array<ReadIdlError>>
	{
        var filePath = sourceReader.getModuleFilePath(baseDirectory, path);
		var content = switch sourceReader.getModule(baseDirectory, path)
        {
            case Option.Some(data):
                data;
                
            case Option.None:
                return Result.Err([new ReadIdlError(filePath, ReadIdlErrorKind.ModuleNotFound(path))]);
        }
        
        var loadedIdl:Maybe<LoadedIdl> = Maybe.none();
		var localPath = Path.join(path.path);
		var errors = [];
        
        inline function errorResult(kind:ReadIdlErrorKind):Void
        {
            errors.push(new ReadIdlError(filePath, kind));
        }
        
		switch (LitllTextToEntityRunner.run(IdlLitllToEntity, content, null, null))
        {
            case Result.Err(errors):
                for (error in errors)
                {
                    errorResult(ReadIdlErrorKind.LitllTextToEntity(error));
                }
                
            case Result.Ok(idl):
                switch (loadedIdl.toOption())
                {
                    case Option.Some(prevIdl):
                        errorResult(ReadIdlErrorKind.ModuleDuplicated(path, prevIdl.file));
                        
                    case Option.None:
                        loadedIdl = Maybe.some(new LoadedIdl(idl, new IdlFilePath(filePath)));
                }
        }
        
        return if (errors.length > 0)
        {
            Result.Err(errors);
        }
        else
        {
            Result.Ok(loadedIdl);
        }
	}
	
    public function getReferencedLibrary(referencerFile:String, referencedName:LibraryName):Result<Library, Array<ReadIdlError>>
    {   
        return if (referencedName.data == name)
        {
            Result.Ok(this);
        }
        else if (config.libraries.exists(referencedName.data))
        {
            scope.getReferencedLibrary(
                referencerFile, 
                referencedName, 
                config.libraries[referencedName.data].version
            );
        }
        else
        {
            Result.Err(
                [
                    new ReadIdlError(filePath, ReadIdlErrorKind.LibraryNotFoundInLibraryConfig(config.tag.upCast(), name, referencedName.data)),
                    new ReadIdlError(referencerFile, ReadIdlErrorKind.LibraryNotFound(referencedName)),
                ]
            );
        }
    }
    
    
}
