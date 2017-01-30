package litll.idl.generator.data;
import haxe.ds.Option;
import litll.idl.generator.data.OutputConfig;
import litll.idl.generator.data.DelitllfierOutputConfig;
import litll.idl.generator.data.SourceConfig;

class ProjectConfig
{
	public var sourceConfig(default, null):SourceConfig;
	public var outputConfig(default, null):OutputConfig;
	
	public function new(
		sourceConfig:SourceConfig, 
		outputConfig:OutputConfig
	):Void
	{
		this.sourceConfig = sourceConfig;
		this.outputConfig = outputConfig;
	}
}
