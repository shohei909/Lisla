package litll.idl.generator.data;
import haxe.ds.Option;
import litll.idl.generator.data.HaxePrintConfig;
import litll.idl.generator.data.LitllToEntityOutputConfig;
import litll.idl.generator.data.SourceConfig;

class ProjectConfig
{
	public var sourceConfig(default, null):SourceConfig;
	
    @:deprecated
    public var outputConfig(default, null):OutputConfig;
    
	public var printConfig(default, null):HaxePrintConfig;
    
	public function new(
		sourceConfig:SourceConfig, 
		outputConfig:OutputConfig,
        printConfig:HaxePrintConfig
	):Void
	{
		this.sourceConfig = sourceConfig;
		this.outputConfig = outputConfig;
	}
}
