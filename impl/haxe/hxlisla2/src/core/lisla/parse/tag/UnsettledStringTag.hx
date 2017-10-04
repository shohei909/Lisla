package lisla.parse.tag;
import haxe.ds.Option;
import hxext.ds.Maybe;
import lisla.data.meta.core.Tag;
import lisla.data.meta.position.CodePointIndex;
import lisla.data.meta.position.Range;
import lisla.data.meta.position.SourceContext;

class UnsettledStringTag
{
	public var leadingTag:UnsettledLeadingTag;
	public var startPosition:CodePointIndex;
	
	public inline function new(leadingTag:UnsettledLeadingTag, startPosition:CodePointIndex) 
	{
		this.leadingTag = leadingTag;
		this.startPosition = startPosition;
	}
	
	public function settle(
        context:SourceContext, 
        position:CodePointIndex,
        innerRanges:Array<Range>
    ):Tag
	{
        var range = Range.createWithEnd(startPosition, position);
		var position = context.getPosition(range);
        var innerPosition = context.getPositionWithRanges(innerRanges);
		var tag = new Tag(position, innerPosition);
		return tag;
	}
}
