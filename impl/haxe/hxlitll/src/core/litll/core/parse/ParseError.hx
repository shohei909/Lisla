package litll.core.parse;
import litll.core.LitllArray;
import haxe.ds.Option;
import litll.core.ds.Maybe;

class ParseError
{
	public var data:Maybe<LitllArray<Litll>>;
	public var entries:Array<ParseErrorEntry>;
	
	public function new(data:Maybe<LitllArray<Litll>>, entries:Array<ParseErrorEntry>) 
	{
		this.data = data;
		this.entries = entries;
	}
	
	public function toString():String
	{
		return [for (entry in entries) entry.toString()].join("\n");
	}
}