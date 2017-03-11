package lisla.core.parse;
import lisla.core.LislaArray;
import haxe.ds.Option;
import hxext.ds.Maybe;
import lisla.core.error.InlineErrorSummary;

class ParseError
{
	public var data:Maybe<LislaArray<Lisla>>;
	public var entries:Array<ParseErrorEntry>;
	
	public function new(data:Maybe<LislaArray<Lisla>>, entries:Array<ParseErrorEntry>) 
	{
		this.data = data;
		this.entries = entries;
	}
	
	public function getSummaries():Array<InlineErrorSummary<ParseErrorKind>>
	{
		return [for (entry in entries) entry.getSummary()];
	}    
}
