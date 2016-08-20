package sora.core.parse.tag;
import unifill.CodePoint;
import haxe.ds.Option;
import sora.core.ds.SourceRange;
import sora.core.parse.ParserConfig;
import sora.core.tag.ArrayTag;

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
		tag.position = Option.Some(new SourceRange(leadingTag.sourceMap, startPosition, position));
		return tag;
	}
	
	public function writeDocument(config:ParserConfig, codePoint:CodePoint, position:Int):Void 
	{
		
	}
}
