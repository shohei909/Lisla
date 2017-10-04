package arraytree.idl.generator.output;
import arraytree.idl.hxarraytree.entity.GenerationConfig;
import arraytree.idl.library.LibraryScope;

class HaxeGenerateConfigFactoryContext 
{
    public var configFilePath(default, null):String;
    public var libraryScope(default, null):LibraryScope;
    public var generationConfig(default, null):GenerationConfig;
    public var requiredLibraryConfigs(default, null):Array<GenerationConfig>;
    
    public function new(
        configFilePath:String,
        libraryScope:LibraryScope,
        generationConfig:GenerationConfig,
        requiredLibraryConfigs:Array<GenerationConfig>
    )
    {
        this.configFilePath = configFilePath;
        this.libraryScope = libraryScope;
        this.generationConfig = generationConfig;
        this.requiredLibraryConfigs = requiredLibraryConfigs;
    }
}
