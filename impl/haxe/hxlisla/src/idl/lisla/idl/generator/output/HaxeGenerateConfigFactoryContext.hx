package lisla.idl.generator.output;
import lisla.idl.hxlisla.entity.config.InputConfig;
import lisla.idl.library.LibraryScope;

class HaxeGenerateConfigFactoryContext 
{
    public var configFilePath(default, null):String;
    public var libraryScope(default, null):LibraryScope;
    public var inputConfig(default, null):InputConfig;
    public var requiredLibraryConfigs(default, null):Array<InputConfig>;
    
    public function new(
        configFilePath:String,
        libraryScope:LibraryScope,
        inputConfig:InputConfig,
        requiredLibraryConfigs:Array<InputConfig>
    )
    {
        this.configFilePath = configFilePath;
        this.libraryScope = libraryScope;
        this.inputConfig = inputConfig;
        this.requiredLibraryConfigs = requiredLibraryConfigs;
    }
}
