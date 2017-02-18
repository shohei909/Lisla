package litll.idl.generator.data;
import haxe.ds.Option;
import hxext.ds.Maybe;
import litll.idl.generator.data.DataOutputConfig;
import litll.idl.generator.data.LitllToEntityOutputConfig;

class OutputConfig
{
	public var outputDirectory:String;
	public var dataOutputConfig:DataOutputConfig;
	public var litllToEntityOutputConfig:Maybe<LitllToEntityOutputConfig>;
	public var indent:String;
	
	public function new(
		outputDirectory:String,
		dataOutputConfig:DataOutputConfig,
		?litllToEntityOutputConfig:Maybe<LitllToEntityOutputConfig>
	):Void
	{
		this.outputDirectory = outputDirectory;
		this.dataOutputConfig = dataOutputConfig;
		this.litllToEntityOutputConfig = if (litllToEntityOutputConfig == null) Maybe.none() else litllToEntityOutputConfig;
		this.indent = "    ";
	}
}
