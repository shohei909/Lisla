package lisla.parse.metadata;
import haxe.ds.Option;
import hxext.ds.Maybe;
import lisla.data.meta.core.Metadata;
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
	
	public function settle(context:SourceContext, position:CodePointIndex):Metadata
	{
        var range = Range.createWithEnd(startPosition, position);
		var position = context.getPosition(range);
		var metadata = new Metadata(position);
		return metadata;
	}
}
