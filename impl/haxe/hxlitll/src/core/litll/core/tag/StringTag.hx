package litll.core.tag;
import litll.core.ds.SourceMap;
import litll.core.ds.SourceRange;
import litll.core.tag.entry.StringFormatTagEntry;
import litll.core.tag.entry.StringKind;
import unifill.CodePoint;
import litll.core.parse.ParserConfig;
import haxe.ds.Option;

class StringTag extends Tag
{
	public var format:Option<StringFormatTagEntry>;
	public var stringKind:Option<StringKind>;
	public var innerMap:Option<SourceMap>;
	
	public function new() 
	{
		super();
		format = Option.None;
		innerMap = Option.None;
		stringKind = Option.None;
	}
}
