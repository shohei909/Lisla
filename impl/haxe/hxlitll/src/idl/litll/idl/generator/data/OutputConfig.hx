package litll.idl.generator.data;
import haxe.ds.Option;
import litll.core.ds.Maybe;
import litll.idl.generator.data.DataOutputConfig;
import litll.idl.generator.data.DelitllfierOutputConfig;

class OutputConfig
{
	public var outputDirectory:String;
	public var dataOutputConfig:DataOutputConfig;
	public var delitllfierOutputConfig:Maybe<DelitllfierOutputConfig>;
	public var indent:String;
	
	public function new(
		outputDirectory:String,
		dataOutputConfig:DataOutputConfig,
		?delitllfierOutputConfig:Maybe<DelitllfierOutputConfig>
	):Void
	{
		this.outputDirectory = outputDirectory;
		this.dataOutputConfig = dataOutputConfig;
		this.delitllfierOutputConfig = if (delitllfierOutputConfig == null) Maybe.none() else delitllfierOutputConfig;
		this.indent = "    ";
	}
}