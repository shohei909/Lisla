package lisla.parse.tag;
import haxe.ds.Option;
import hxext.ds.Maybe;
import lisla.data.meta.core.Metadata;
import lisla.data.meta.position.CodePointIndex;
import lisla.data.meta.position.Range;
class UnsettledStringTag
{
	public var leadingTag:UnsettledLeadingTag;
	public var startPosition:CodePointIndex;
	
	public inline function new(leadingTag:UnsettledLeadingTag, startPosition:CodePointIndex) 
	{
		this.leadingTag = leadingTag;
		this.startPosition = startPosition;
	}
	
	public function settle(position:CodePointIndex):Metadata
	{
		var tag = new Metadata();
		tag.range = Option.Some(Range.createWithEnd(startPosition, position));
		return tag;
	}
}
