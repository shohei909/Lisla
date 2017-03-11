package litll.idl.generator.output;
import hxext.ds.Result;
import litll.idl.generator.data.EntityOutputConfig;
import litll.idl.generator.data.LitllToEntityOutputConfig;
import litll.idl.generator.error.ReadIdlError;
import litll.idl.generator.output.entity.store.HaxeEntityInterface;
import litll.idl.generator.output.entity.store.HaxeEntityInterfaceKindTools;
import litll.idl.generator.source.IdlSourceReader;
import litll.idl.hxlitll.data.config.TargetConfig;
import litll.idl.library.LibraryScope;
import litll.idl.library.LibraryTypesData;
import litll.idl.std.data.idl.LibraryName;
import litll.idl.std.data.idl.library.LibraryVersion;
import litll.idl.std.data.util.version.Version;

class HaxeGenerateConfig
{
    public var configFilePath(default, null):String;
    public var libraryScope(default, null):LibraryScope;
    public var sourceReader(default, null):IdlSourceReader;
    public var entityOutputConfig(default, null):EntityOutputConfig;
    public var litllToEntityOutputConfig(default, null):LitllToEntityOutputConfig;
    public var targetName(default, null):LibraryName;
    public var targetVersion(default, null):Version;
    
    public function new(
        configFilePath:String,
        libraryScope:LibraryScope,
        targetName:LibraryName,
        targetVersion:Version,
        entityOutputConfig:EntityOutputConfig,
        litllToEntityOutputConfig:LitllToEntityOutputConfig,
        sourceReader:IdlSourceReader
    )
    {
        this.targetVersion = targetVersion;
        this.configFilePath = configFilePath;
        this.libraryScope = libraryScope;
        this.targetName = targetName;
        this.entityOutputConfig = entityOutputConfig;
        this.litllToEntityOutputConfig = litllToEntityOutputConfig;
        this.sourceReader = sourceReader;
    }
    
    public function resolveTargets():Result<LibraryTypesData, Array<ReadIdlError>>
    {
        var library = switch libraryScope.getReferencedLibrary(
            configFilePath,
            targetName, 
            LibraryVersion.Version(targetVersion)
        )
        {
            case Result.Ok(_library):
                _library;
                
            case Result.Err(errors):
                return Result.Err(errors);
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
                
            case Result.Err(error):
                Result.Err(error);
        }
    }
    
}
