package lisla.core.parse.tag;
import hxext.ds.Maybe;
import unifill.CodePoint;
import haxe.ds.Option;
import lisla.core.ds.SourceRange;
import lisla.core.parse.ParserConfig;
import lisla.core.tag.ArrayTag;

class UnsettledArrayTag
{
	public var leadingTag(default, null):UnsettledLeadingTag;
	public var startPosition(default, null):Int;
	
	public inline function new(leadingTag:UnsettledLeadingTag, startPosition:Int) 
	{
		this.leadingTag = leadingTag;
		this.startPosition = startPosition;
	}
	
	public function settle(position:Int):ArrayTag
	{
		var tag = new ArrayTag();
		tag.range = Maybe.some(new SourceRange(leadingTag.sourceMap, startPosition, position));
		return tag;
	}
	
	public function writeDocument(config:ParserConfig, codePoint:CodePoint, position:Int):Void 
	{
		
	}
}
