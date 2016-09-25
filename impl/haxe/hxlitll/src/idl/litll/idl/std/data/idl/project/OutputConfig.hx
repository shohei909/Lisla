package litll.idl.std.data.idl.project;
import haxe.ds.Option;
import litll.idl.std.data.idl.path.TypeGroupPath;
import litll.idl.std.data.idl.path.TypePathFilter;
import litll.idl.std.data.idl.project.DelitllfierOutputConfig;

class OutputConfig
{
	public var outputDirectory:String;
	public var dataOutputConfig:DataOutputConfig;
	public var delitllfierOutputConfig:Option<DelitllfierOutputConfig>;
	public var indent:String;
	
	public function new(
		outputDirectory:String,
		dataOutputConfig:DataOutputConfig,
		delitllfierOutputConfig:Option<DelitllfierOutputConfig> = null
	):Void
	{
		this.outputDirectory = outputDirectory;
		this.dataOutputConfig = dataOutputConfig;
		this.delitllfierOutputConfig = if (delitllfierOutputConfig == null) Option.None else delitllfierOutputConfig;
		this.indent = "    ";
	}
}
