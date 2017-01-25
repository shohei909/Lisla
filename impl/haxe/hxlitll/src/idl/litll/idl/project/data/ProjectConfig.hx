package litll.idl.project.data;
import haxe.ds.Option;
import litll.idl.project.data.OutputConfig;
import litll.idl.project.data.DelitllfierOutputConfig;
import litll.idl.project.data.SourceConfig;

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
