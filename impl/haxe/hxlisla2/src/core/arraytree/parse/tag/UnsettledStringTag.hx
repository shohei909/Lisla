package arraytree.parse.tag;
import haxe.ds.Option;
import hxext.ds.Maybe;
import arraytree.data.meta.core.Tag;
import arraytree.data.meta.position.CodePointIndex;
import arraytree.data.meta.position.Range;
import arraytree.data.meta.position.SourceContext;

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
