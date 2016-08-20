package sora.core.tag;
import sora.core.ds.SourceMap;
import sora.core.ds.SourceRange;
import sora.core.tag.entry.StringFormatTagEntry;
import sora.core.tag.entry.StringKind;
import unifill.CodePoint;
import sora.core.parse.ParserConfig;
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
