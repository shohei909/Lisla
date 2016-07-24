package format.sora.parser;
import format.sora.data.SoraArray;
import haxe.ds.Option;

class ParseError
{
	public var data:Option<SoraArray>;
	public var entries:Array<ParseErrorEntry>;
	
	public function new(data:Option<SoraArray>, entries:Array<ParseErrorEntry>) 
	{
		this.data = data;
		this.entries = entries;
	}
}