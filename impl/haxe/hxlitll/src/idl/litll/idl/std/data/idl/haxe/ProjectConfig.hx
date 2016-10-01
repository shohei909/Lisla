package litll.idl.std.data.idl.haxe;
import haxe.ds.Option;
import litll.idl.std.data.idl.haxe.OutputConfig;
import litll.idl.std.data.idl.haxe.DelitllfierOutputConfig;
import litll.idl.std.data.idl.haxe.SourceConfig;

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
