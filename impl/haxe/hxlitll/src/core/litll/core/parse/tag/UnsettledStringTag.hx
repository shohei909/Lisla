package litll.core.parse.tag;
import haxe.ds.Option;
import hxext.ds.Maybe;
import litll.core.ds.SourceRange;
import litll.core.tag.ArrayTag;
import litll.core.tag.StringTag;

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
		tag.position = Maybe.some(new SourceRange(leadingTag.sourceMap, startPosition, position));
		return tag;
	}
}
