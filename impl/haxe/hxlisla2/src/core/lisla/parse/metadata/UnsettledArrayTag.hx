package lisla.parse.metadata;
import haxe.ds.Option;
import hxext.ds.Maybe;
import lisla.data.meta.core.Metadata;
import lisla.data.meta.position.CodePointIndex;
import lisla.data.meta.position.Range;
import lisla.data.meta.position.SourceContext;

class UnsettledArrayTag
{
	public var leadingTag(default, null):UnsettledLeadingTag;
	public var startPosition(default, null):CodePointIndex;
	
	public inline function new(leadingTag:UnsettledLeadingTag, startPosition:CodePointIndex) 
	{
		this.leadingTag = leadingTag;
		this.startPosition = startPosition;
	}
	
	public function settle(context:SourceContext, position:CodePointIndex, footerTag:UnsettledLeadingTag):Metadata
	{
        var range = Range.createWithEnd(startPosition, position);
        var position = context.getPosition(range);
		var metadata = new Metadata(position);
        
        // TODO: Document comment
        // TODO: Concat footerTag
        
		return metadata;
	}
}
