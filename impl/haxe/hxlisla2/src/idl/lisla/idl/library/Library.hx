package arraytree.idl.library;

import haxe.ds.Option;
import hxext.ds.Maybe;
import hxext.ds.Result;
import arraytree.data.meta.core.Metadata;
import arraytree.data.meta.position.Range;
import arraytree.data.meta.position.SourceMap;
import arraytree.data.tree.al.AlTreeBlock;
import arraytree.idl.generator.error.IdlLibraryFactorError;
import arraytree.idl.generator.error.IdlLibraryFactorErrorKind;
import arraytree.idl.generator.error.IdlLibraryFactorErrorKind;
import arraytree.idl.generator.error.LibraryResolutionError;
import arraytree.idl.generator.error.LibraryResolutionErrorKind;
import arraytree.idl.generator.error.LibraryFindError;
import arraytree.idl.generator.error.LibraryFindErrorKind;
import arraytree.idl.generator.error.LoadIdlError;
import arraytree.idl.generator.error.LoadIdlErrorKind;
import arraytree.idl.generator.error.ModuleNotFoundError;
import arraytree.idl.generator.source.IdlSourceReader;
import arraytree.idl.generator.source.file.LoadedModule;
import arraytree.idl.generator.source.validate.ValidType;
import arraytree.idl.library.PackageElement;
import arraytree.idl.library.error.LibraryReadModuleError;
import arraytree.idl.library.error.LibraryReadModuleErrorKind;
import arraytree.idl.library.error.ModuleResolutionError;
import arraytree.idl.library.error.ModuleResolutionErrorKind;
import arraytree.idl.arraytreetext2entity.ArrayTreeTextToEntityRunner;
import arraytree.idl.std.entity.idl.LibraryName;
import arraytree.idl.std.entity.idl.ModulePath;
import arraytree.idl.std.entity.idl.PackagePath;
import arraytree.idl.std.entity.idl.TypeName;
import arraytree.idl.std.entity.idl.library.LibraryConfig;
import arraytree.idl.std.entity.util.file.FilePath;
import arraytree.idl.std.arraytree2entity.idl.IdlArrayTreeToEntity;
import arraytree.project.FileSourceMap;
import arraytree.project.FilePathFromProjectRoot;
import arraytree.project.FileSourceRange;
import arraytree.project.ProjectRootAndFilePath;
import arraytree.project.ProjectRootDirectory;

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
        
		return switch (ArrayTreeTextToEntityRunner.run(IdlArrayTreeToEntity, content, null, null))
        {
            case Result.Error(errors):
                Result.Error(
                    [for (error in errors) LibraryReadModuleError.ofArrayTreeTextToEntity(error, rootAndFilePath)]
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
