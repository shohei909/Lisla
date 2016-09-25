package litll.core.parse;
import litll.core.LitllArray;
import haxe.ds.Option;

class ParseError
{
	public var data:Option<LitllArray>;
	public var entries:Array<ParseErrorEntry>;
	
	public function new(data:Option<LitllArray>, entries:Array<ParseErrorEntry>) 
	{
		this.data = data;
		this.entries = entries;
	}
	
	public function toString():String
	{
		return entries.join("\n");
	}
}