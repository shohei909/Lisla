package litll.idl.generator.data;
import haxe.ds.Option;
import hxext.ds.Maybe;
import litll.idl.generator.data.EntityOutputConfig;
import litll.idl.generator.data.LitllToEntityOutputConfig;

class HaxePrintConfig
{
	public var outputDirectory:String;
	public var indent:String;
	
	public function new(outputDirectory:String):Void
	{
		this.outputDirectory = outputDirectory;
		this.indent = "    ";
	}
}
