package lisla.core.parse.tag;
import haxe.ds.Option;
import hxext.ds.Maybe;
import lisla.core.ds.SourceRange;
import lisla.core.tag.ArrayTag;
import lisla.core.tag.StringTag;

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
		tag.range = Maybe.some(new SourceRange(leadingTag.sourceMap, startPosition, position));
		return tag;
	}
}
