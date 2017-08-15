package lisla.idl.generator.output;
import haxe.ds.Option;
import hxext.ds.Result;
import lisla.idl.generator.error.IdlLibraryFactorError;
import lisla.project.FilePathFromProjectRoot;
import lisla.idl.generator.data.EntityOutputConfig;
import lisla.idl.generator.data.LislaToEntityOutputConfig;
import lisla.idl.generator.error.LoadIdlError;
import lisla.idl.generator.output.entity.store.HaxeEntityInterface;
import lisla.idl.generator.output.entity.store.HaxeEntityInterfaceKindTools;
import lisla.idl.generator.source.IdlSourceReader;
import lisla.idl.library.LibraryScope;
import lisla.idl.library.LibraryTypesData;
import lisla.idl.std.entity.idl.LibraryName;
import lisla.idl.std.entity.idl.library.LibraryVersion;
import lisla.idl.std.entity.util.version.Version;
import lisla.project.FileSourceMap;
import lisla.project.FileSourceRange;
import lisla.project.ProjectRootAndFilePath;

class HaxeGenerateConfig
{
    public var configFileSourceMap(default, null):FileSourceMap;
    public var libraryScope(default, null):LibraryScope;
    public var sourceReader(default, null):IdlSourceReader;
    public var entityOutputConfig(default, null):EntityOutputConfig;
    public var lislaToEntityOutputConfig(default, null):LislaToEntityOutputConfig;
    public var targetName(default, null):LibraryName;
    public var targetVersion(default, null):Version;
    
    public function new(
        configFileSourceMap:FileSourceMap,
        libraryScope:LibraryScope,
        targetName:LibraryName,
        targetVersion:Version,
        entityOutputConfig:EntityOutputConfig,
        lislaToEntityOutputConfig:LislaToEntityOutputConfig,
        sourceReader:IdlSourceReader
    )
    {
        this.targetVersion = targetVersion;
        this.configFileSourceMap = configFileSourceMap;
        this.libraryScope = libraryScope;
        this.targetName = targetName;
        this.entityOutputConfig = entityOutputConfig;
        this.lislaToEntityOutputConfig = lislaToEntityOutputConfig;
        this.sourceReader = sourceReader;
    }
    
    public function resolveTargets():Result<LibraryTypesData, Array<LoadIdlError>>
    {
        var library = switch libraryScope.getLibrary(
            targetName, 
            LibraryVersion.Version(targetVersion)
        )
        {
            case Result.Ok(_library):
                _library;
                
            case Result.Error(error):
                var resultErrors = [];
                resultErrors.push(
                    LoadIdlError.fromLibraryFind(
                        error,
                        Option.Some(
                            FileSourceRange.fromFileSourceMap(
                                configFileSourceMap,
                                targetName.metadata.range
                            )
                        )
                    )
                );
                return Result.Error(resultErrors);
        }
        
        return switch library.loadTypes()
        {
            case Result.Ok(types):
                var infomations = [
                    for (type in types)
                    {
                        var entityOutputConfig = entityOutputConfig;
                        var haxePath = entityOutputConfig.toHaxePath(type.typePath);
                        
                        var entityInterface = if (entityOutputConfig.predefinedTypes.exists(haxePath.toString()))
                        {
                            entityOutputConfig.predefinedTypes[haxePath.toString()];
                        }
                        else
                        {
                            var kind = HaxeEntityInterfaceKindTools.createDefault(type.definition);
                            new HaxeEntityInterface(haxePath, kind);
                        }
                        
                        new EntityTypeInfomation(type, entityInterface);
                    }
                ];
                
                Result.Ok(new LibraryTypesData(library, infomations));
                
            case Result.Error(error):
                Result.Error(error);
        }
    }
    
}
