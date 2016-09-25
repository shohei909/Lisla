package litll.idl.std.data.idl.project;
import haxe.ds.Option;
import litll.idl.std.data.idl.project.OutputConfig;
import litll.idl.std.data.idl.project.LitllfierOutputConfig;
import litll.idl.std.data.idl.project.SourceConfig;

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
