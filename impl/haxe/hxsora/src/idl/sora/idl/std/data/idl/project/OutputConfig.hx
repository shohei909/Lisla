package sora.idl.std.data.idl.project;
import haxe.ds.Option;
import sora.idl.std.data.idl.path.TypeGroupPath;
import sora.idl.std.data.idl.path.TypeRenameFilter;
import sora.idl.std.data.idl.project.DesoralizerOutputConfig;

class OutputConfig
{
	public var outputDirectory:String;
	public var dataOutputConfig:DataOutputConfig;
	public var desoralizerOutputConfig:Option<DesoralizerOutputConfig>;
	
	public function new(
		outputDirectory:String,
		dataOutputConfig:DataOutputConfig,
		desoralizerOutputConfig:Option<DesoralizerOutputConfig> = null
	):Void
	{
		this.outputDirectory = outputDirectory;
		this.dataOutputConfig = dataOutputConfig;
		this.desoralizerOutputConfig = if (desoralizerOutputConfig == null) Option.None else desoralizerOutputConfig;
	}
}
