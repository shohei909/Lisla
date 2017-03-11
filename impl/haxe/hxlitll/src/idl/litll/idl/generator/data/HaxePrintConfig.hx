package lisla.idl.generator.data;
import haxe.ds.Option;
import hxext.ds.Maybe;
import lisla.idl.generator.data.EntityOutputConfig;
import lisla.idl.generator.data.LislaToEntityOutputConfig;

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
