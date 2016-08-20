package sora.core.parse;
import sora.core.SoraArray;
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
	
	public function toString():String
	{
		return entries.join("\n");
	}
}