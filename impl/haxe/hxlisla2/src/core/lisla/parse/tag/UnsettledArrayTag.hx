package lisla.parse.tag;
import haxe.ds.Option;
import hxext.ds.Maybe;
import lisla.data.meta.core.Metadata;
import lisla.data.meta.position.CodePointIndex;
import lisla.data.meta.position.Range;

class UnsettledArrayTag
{
	public var leadingTag(default, null):UnsettledLeadingTag;
	public var startPosition(default, null):CodePointIndex;
	
	public inline function new(leadingTag:UnsettledLeadingTag, startPosition:CodePointIndex) 
	{
		this.leadingTag = leadingTag;
		this.startPosition = startPosition;
	}
	
	public function settle(position:CodePointIndex, footerTag:UnsettledLeadingTag):Metadata
	{
		var tag = new Metadata();
		tag.range = Option.Some(Range.createWithEnd(startPosition, position));
        
        // TODO: Document comment
        // TODO: Concat footerTag
        
		return tag;
	}
}
