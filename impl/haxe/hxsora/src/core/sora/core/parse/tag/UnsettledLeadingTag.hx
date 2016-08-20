package sora.core.parse.tag;
import unifill.CodePoint;
import sora.core.ds.SourceMap;
import sora.core.parse.ParserConfig;
import sora.core.tag.ArrayTag;

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
