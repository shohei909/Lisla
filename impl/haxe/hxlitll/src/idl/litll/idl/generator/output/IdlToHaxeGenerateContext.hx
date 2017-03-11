package litll.idl.generator.output;
import hxext.ds.Result;
import litll.idl.generator.data.EntityOutputConfig;
import litll.idl.generator.data.LitllToEntityOutputConfig;
import litll.idl.generator.error.ReadIdlError;
import litll.idl.generator.output.entity.store.HaxeEntityInterface;
import litll.idl.generator.output.entity.store.HaxeEntityInterfaceKindTools;
import litll.idl.generator.source.IdlFileSourceReader;
import litll.idl.generator.source.IdlSourceReader;
import litll.idl.hxlitll.data.config.InputConfig;
import litll.idl.library.LibraryScope;
import litll.idl.library.LibraryTypesData;
import litll.idl.std.data.idl.library.LibraryVersion;
import litll.project.LitllProject;

class IdlToHaxeGenerateContext
{
    private var litllProject:LitllProject;
    private var inputFilePath:String;
    private var inputConfig:InputConfig;
    
    public var libraryScope(default, null):LibraryScope;
    public var sourceReader(default, null):IdlSourceReader;
    
    public var entityOutputConfig:EntityOutputConfig;
    public var litllToEntityOutputConfig:LitllToEntityOutputConfig;
    
    public function new(
        litllProject:LitllProject, 
        inputFilePath:String, 
        inputConfig:InputConfig, 
        libraryScope:LibraryScope
    )
    {
        this.litllProject = litllProject;
        
        this.inputFilePath = inputFilePath;
        this.inputConfig = inputConfig;
        this.libraryScope = libraryScope;
        
        this.litllToEntityOutputConfig = new LitllToEntityOutputConfig([]);
        this.entityOutputConfig = new EntityOutputConfig([]);
        
        this.sourceReader = new IdlFileSourceReader();
    }
    
    public function resolveTargets():Result<LibraryTypesData, Array<ReadIdlError>>
    {
        var library = switch libraryScope.getReferencedLibrary(
            inputFilePath, 
            inputConfig.target.name, 
            LibraryVersion.Version(inputConfig.target.data.version)
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
