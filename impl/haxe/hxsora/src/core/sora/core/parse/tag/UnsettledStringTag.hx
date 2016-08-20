package sora.core.parse.tag;
import haxe.ds.Option;
import sora.core.ds.SourceRange;
import sora.core.tag.ArrayTag;
import sora.core.tag.StringTag;

class UnsettledStringTag
{
	public var leadingTag:UnsettledLeadingTag;
	public var startPosition:Int;
	
	public inline function new(leadingTag:UnsettledLeadingTag, startPosition:Int) 
	{
		this.leadingTag = leadingTag;
		this.startPosition = startPosition;
	}
	
	public function settle(position:Int):StringTag
	{
		var tag = new StringTag();
		tag.position = Option.Some(new SourceRange(leadingTag.sourceMap, startPosition, position));
		return tag;
	}
}
