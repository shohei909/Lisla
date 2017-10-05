package lisla.parse.tag;
import haxe.ds.Option;
import hxext.ds.Maybe;
import lisla.data.meta.core.Tag;
import lisla.data.meta.position.CodePointIndex;
import lisla.data.meta.position.Range;
import lisla.data.meta.position.SourceContext;

class UnsettledArrayTag
{
    public var isTop(default, null):Bool;
	public var leadingTag(default, null):UnsettledLeadingTag;
	public var startPosition(default, null):CodePointIndex;
	
	public inline function new(
        isTop:Bool,
        leadingTag:UnsettledLeadingTag, 
        startPosition:CodePointIndex
    ) 
	{
        this.isTop = isTop;
		this.leadingTag = leadingTag;
		this.startPosition = startPosition;
	}
	
	public function settle(context:SourceContext, position:CodePointIndex, footerTag:UnsettledLeadingTag):Tag
	{
        var range = Range.createWithEnd(startPosition, position);
        var innerRange = if (isTop) 
        {
            range;
        }
        else
        {
            Range.createWithEnd(startPosition + 1, position - 1);
        }
        
		var tag = new Tag(
            context.getPosition(range),
            context.getPosition(innerRange)
        );
        
        // TODO: Document comment
        // TODO: Concat footerTag
        
		return tag;
	}
}
