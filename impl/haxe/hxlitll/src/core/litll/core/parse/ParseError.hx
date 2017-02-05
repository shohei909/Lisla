package litll.core.parse;
import litll.core.LitllArray;
import haxe.ds.Option;
import litll.core.ds.Maybe;
import litll.core.error.LitllErrorSummary;

class ParseError
{
	public var data:Maybe<LitllArray<Litll>>;
	public var entries:Array<ParseErrorEntry>;
	
	public function new(data:Maybe<LitllArray<Litll>>, entries:Array<ParseErrorEntry>) 
	{
		this.data = data;
		this.entries = entries;
	}
	
	public function getSummaries():Array<LitllErrorSummary>
	{
		return [for (entry in entries) entry.getSummary()];
	}
    
}
