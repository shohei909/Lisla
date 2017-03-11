package lisla.core.tag;
import hxext.ds.Maybe;
import lisla.core.ds.SourceMap;
import lisla.core.ds.SourceRange;
import lisla.core.tag.entry.StringFormatTagEntry;
import lisla.core.tag.entry.StringKind;
import unifill.CodePoint;
import lisla.core.parse.ParserConfig;
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
