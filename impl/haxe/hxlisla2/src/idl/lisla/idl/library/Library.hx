package lisla.idl.library;

import haxe.ds.Option;
import hxext.ds.Maybe;
import hxext.ds.Result;
import lisla.data.meta.core.Metadata;
import lisla.data.meta.position.Range;
import lisla.data.meta.position.SourceMap;
import lisla.data.tree.al.AlTreeBlock;
import lisla.idl.generator.error.IdlLibraryFactorError;
import lisla.idl.generator.error.IdlLibraryFactorErrorKind;
import lisla.idl.generator.error.IdlLibraryFactorErrorKind;
import lisla.idl.generator.error.LibraryResolutionError;
import lisla.idl.generator.error.LibraryResolutionErrorKind;
import lisla.idl.generator.error.LibraryFindError;
import lisla.idl.generator.error.LibraryFindErrorKind;
import lisla.idl.generator.error.LoadIdlError;
import lisla.idl.generator.error.LoadIdlErrorKind;
import lisla.idl.generator.error.ModuleNotFoundError;
import lisla.idl.generator.source.IdlSourceReader;
import lisla.idl.generator.source.file.LoadedModule;
import lisla.idl.generator.source.validate.ValidType;
import lisla.idl.library.PackageElement;
import lisla.idl.library.error.LibraryReadModuleError;
import lisla.idl.library.error.LibraryReadModuleErrorKind;
import lisla.idl.library.error.ModuleResolutionError;
import lisla.idl.library.error.ModuleResolutionErrorKind;
import lisla.idl.lislatext2entity.LislaTextToEntityRunner;
import lisla.idl.std.entity.idl.LibraryName;
import lisla.idl.std.entity.idl.ModulePath;
import lisla.idl.std.entity.idl.PackagePath;
import lisla.idl.std.entity.idl.TypeName;
import lisla.idl.std.entity.idl.library.LibraryConfig;
import lisla.idl.std.entity.util.file.FilePath;
import lisla.idl.std.lisla2entity.idl.IdlLislaToEntity;
import lisla.project.FileSourceMap;
import lisla.project.FilePathFromProjectRoot;
import lisla.project.FileSourceRange;
import lisla.project.ProjectRootAndFilePath;
import lisla.project.ProjectRootDirectory;

class Library extends PackageElement implements LibraryResolver
{
    // ========================
    // Parent
    // ========================
    private var series:LibrarySeries;
        
    // ========================
    // Children
    // ========================
    private var projectRoot:ProjectRootDirectory;
    private var baseDirectory:FilePathFromProjectRoot;
    private var name:String;
    
    private var config:LibraryConfig;
    public var configFileSourceRange:Option<FileSourceRange>;
    
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
        filePath:ProjectRootAndFilePath,
        name:String, 
        sourceReader:IdlSourceReader,
        config:LibraryConfig,
        configFileSourceMap:Option<FileSourceMap>
    )
    {
        this.configFileSourceMap = configFileSourceMap;
        this.projectRoot = filePath.projectRoot;
        this.baseDirectory = filePath.filePath;
        this.config = config;
        this.series = series;
        this.name = name;
        this.sourceReader = sourceReader;
        
        super(this, new PackagePath([name], new Metadata()));
    }
    
    public function loadTypes():Result<Array<ValidType>, Array<LoadIdlError>>
    {
        var context:LoadTypesContext = new LoadTypesContext();
        var types:Array<ValidType> = [];
        
        fetchChildren(context, types);
        
        return if (context.errors.length > 0)
        {
            Result.Error(context.errors);
        }
        else
        {
            Result.Ok(types);
        }
    }
    
    public function loadType(modulePath:ModulePath, typeName:TypeName):Result<Maybe<ValidType>, Array<LoadIdlError>>
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
            Result.Error(context.errors);
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
    
	public function readModuleAt(
        path:ModulePath
    ):Result<LoadedModule, Array<LibraryReadModuleError>>
	{
        var filePath = sourceReader.getModuleFilePath(baseDirectory, path);
        var rootAndFilePath = projectRoot.makePair(filePath);
        
		var content = switch sourceReader.getModule(baseDirectory, path)
        {
            case Option.Some(data):
                data;
                
            case Option.None:
                var moduleError = new ModuleNotFoundError(module, configFileSourceRange);
                return Result.Error(
                    [
                        new IdlLibraryFactorError(
                            IdlLibraryFactorErrorKind.NotFound(moduleError)
                        )
                    ]
                );
        }
        
		return switch (LislaTextToEntityRunner.run(IdlLislaToEntity, content, null, null))
        {
            case Result.Error(errors):
                Result.Error(
                    [for (error in errors) LibraryReadModuleError.ofLislaTextToEntity(error, rootAndFilePath)]
                );
                
            case Result.Ok(idl):
                Result.Ok(new LoadedModule(idl, rootAndFilePath));
        }
	}
	
    public function getLibrary(
        libraryName:LibraryName
    ):Result<Library, LibraryResolutionError>
    {
        return if (libraryName.data == name)
        {
            Result.Ok(this);
        }
        else if (config.libraries.exists(libraryName.data))
        {
            var libraryReference = config.libraries[libraryName.data];
            var library = scope.getLibrary(libraryName, libraryReference.version);
            
            switch (library)
            {
                case Result.Ok(ok):
                    Result.Ok(ok);
                    
                case Result.Error(error):
                    Result.Error(
                        new LibraryResolutionError(
                            LibraryResolutionErrorKind.Find(error),
                            configFileSourceRange
                        )
                    );
            }
        }
        else
        {
            Result.Error(
                new LibraryResolutionError(
                    LibraryResolutionErrorKind.NotFoundInConfig(libraryName.data),
                    configFileSourceRange
                )
            );
        }
    }
    
    
    public function resolveModuleElement(
        modulePath:ModulePath
    ):Result<PackageElement, ModuleResolutionError>
    {
        var targetLibrary = switch(getLibrary(modulePath.libraryName))
        {
            case Result.Ok(_library):
                _library;
                
            case Result.Error(error):
                return Result.Error(
                    new ModuleResolutionError(
                        ModuleResolutionErrorKind.LibraryResolution(error)
                    )
                );
        }
        
        return switch (targetLibrary.getModuleElement(modulePath).toOption())
        {
            case Option.Some(element) if (element.hasModule(context)):
                Result.Ok(element);
                
            case _:
                var error = new ModuleNotFoundError(
                    importTarget.module,
                    targetLibrary.configFileSourceRange
                );
                
                Result.Error(
                    new ModuleResolutionError(
                        ModuleResolutionErrorKind.NotFound(error)
                    )
                );
        }
    }
}
