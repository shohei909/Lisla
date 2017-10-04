package arraytree.idl.generator.output;
import haxe.ds.Option;
import hxext.ds.Result;
import arraytree.idl.generator.error.IdlLibraryFactorError;
import arraytree.project.FilePathFromProjectRoot;
import arraytree.idl.generator.data.EntityOutputConfig;
import arraytree.idl.generator.data.ArrayTreeToEntityOutputConfig;
import arraytree.idl.generator.error.LoadIdlError;
import arraytree.idl.generator.output.entity.store.HaxeEntityInterface;
import arraytree.idl.generator.output.entity.store.HaxeEntityInterfaceKindTools;
import arraytree.idl.generator.source.IdlSourceReader;
import arraytree.idl.library.LibraryScope;
import arraytree.idl.library.LibraryTypesData;
import arraytree.idl.std.entity.idl.LibraryName;
import arraytree.idl.std.entity.idl.library.LibraryVersion;
import arraytree.idl.std.entity.util.version.Version;
import arraytree.project.FileSourceMap;
import arraytree.project.FileSourceRange;
import arraytree.project.ProjectRootAndFilePath;

class HaxeGenerateConfig
{
    public var configFileSourceMap(default, null):FileSourceMap;
    public var libraryScope(default, null):LibraryScope;
    public var sourceReader(default, null):IdlSourceReader;
    public var entityOutputConfig(default, null):EntityOutputConfig;
    public var arraytreeToEntityOutputConfig(default, null):ArrayTreeToEntityOutputConfig;
    public var targetName(default, null):LibraryName;
    public var targetVersion(default, null):Version;
    
    public function new(
        configFileSourceMap:FileSourceMap,
        libraryScope:LibraryScope,
        targetName:LibraryName,
        targetVersion:Version,
        entityOutputConfig:EntityOutputConfig,
        arraytreeToEntityOutputConfig:ArrayTreeToEntityOutputConfig,
        sourceReader:IdlSourceReader
    )
    {
        this.targetVersion = targetVersion;
        this.configFileSourceMap = configFileSourceMap;
        this.libraryScope = libraryScope;
        this.targetName = targetName;
        this.entityOutputConfig = entityOutputConfig;
        this.arraytreeToEntityOutputConfig = arraytreeToEntityOutputConfig;
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
