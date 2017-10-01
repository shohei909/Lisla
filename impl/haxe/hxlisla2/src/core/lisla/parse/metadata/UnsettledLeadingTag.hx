package lisla.parse.metadata;
import lisla.data.meta.position.CodePointIndex;
import lisla.data.meta.position.LineIndexes;
import lisla.parse.ParseConfig;
import unifill.CodePoint;

class UnsettledLeadingTag
{
	public inline function new() 
	{
	}
	
	public function writeDocument(config:ParseConfig, codePoint:CodePoint, position:Int):Void
	{
		// TODO
	}
	
	public function toArrayTag(position:CodePointIndex):UnsettledArrayTag
	{
		return new UnsettledArrayTag(this, position);
	}
	
	public function toStringTag(position:CodePointIndex):UnsettledStringTag
	{
		return new UnsettledStringTag(this, position);
	}
	
}
