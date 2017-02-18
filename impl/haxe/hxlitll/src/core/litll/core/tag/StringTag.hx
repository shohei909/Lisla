package litll.core.tag;
import hxext.ds.Maybe;
import litll.core.ds.SourceMap;
import litll.core.ds.SourceRange;
import litll.core.tag.entry.StringFormatTagEntry;
import litll.core.tag.entry.StringKind;
import unifill.CodePoint;
import litll.core.parse.ParserConfig;
import haxe.ds.Option;

class StringTag extends Tag
{
	public var format:Maybe<StringFormatTagEntry>;
	public var stringKind:Maybe<StringKind>;
	public var innerMap:Maybe<SourceMap>;
	
	public function new() 
	{
		super();
		format = Maybe.none();
		innerMap = Maybe.none();
		stringKind = Maybe.none();
	}
}
