package litll.idl.generator.data;
import haxe.ds.Option;
import litll.core.ds.Maybe;
import litll.idl.generator.data.DataOutputConfig;
import litll.idl.generator.data.LitllToBackendOutputConfig;

class OutputConfig
{
	public var outputDirectory:String;
	public var dataOutputConfig:DataOutputConfig;
	public var litllToBackendOutputConfig:Maybe<LitllToBackendOutputConfig>;
	public var indent:String;
	
	public function new(
		outputDirectory:String,
		dataOutputConfig:DataOutputConfig,
		?litllToBackendOutputConfig:Maybe<LitllToBackendOutputConfig>
	):Void
	{
		this.outputDirectory = outputDirectory;
		this.dataOutputConfig = dataOutputConfig;
		this.litllToBackendOutputConfig = if (litllToBackendOutputConfig == null) Maybe.none() else litllToBackendOutputConfig;
		this.indent = "    ";
	}
}
