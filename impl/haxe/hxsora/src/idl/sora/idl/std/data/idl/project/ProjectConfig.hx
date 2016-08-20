package sora.idl.std.data.idl.project;
import haxe.ds.Option;
import sora.idl.std.data.idl.project.OutputConfig;
import sora.idl.std.data.idl.project.DesoralizerOutputConfig;
import sora.idl.std.data.idl.project.SourceConfig;

class ProjectConfig
{
	public var sourceConfig(default, null):SourceConfig;
	public var outputConfig(default, null):OutputConfig;
	
	private function new(
		sourceConfig:SourceConfig, 
		outputConfig:OutputConfig, 
	):Void
	{
		this.sourceConfig = sourceConfig;
		this.dataOutputConfig = dataOutputConfig;
	}
}
