package arraytree.idl.generator.data;
import haxe.ds.Option;
import hxext.ds.Maybe;
import arraytree.idl.generator.data.EntityOutputConfig;
import arraytree.idl.generator.data.ArrayTreeToEntityOutputConfig;

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
