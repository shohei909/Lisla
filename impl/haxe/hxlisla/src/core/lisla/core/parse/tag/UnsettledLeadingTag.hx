package lisla.core.parse.tag;
import unifill.CodePoint;
import lisla.core.ds.SourceMap;
import lisla.core.parse.ParserConfig;
import lisla.core.tag.ArrayTag;

class UnsettledLeadingTag
{
	public var sourceMap:SourceMap;
	
	public inline function new(sourceMap:SourceMap) 
	{
		this.sourceMap = sourceMap;
}
	
	public function writeDocument(config:ParserConfig, codePoint:CodePoint, position:Int):Void
	{
		// TODO
	}
	
	public function toArrayTag(position:Int):UnsettledArrayTag
	{
		return new UnsettledArrayTag(this, position);
	}
	
	public function toStringTag(position:Int):UnsettledStringTag
	{
		return new UnsettledStringTag(this, position);
	}
	
}
