package litll.core.parse.tag;
import unifill.CodePoint;
import litll.core.ds.SourceMap;
import litll.core.parse.ParserConfig;
import litll.core.tag.ArrayTag;

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
