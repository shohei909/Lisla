package lisla.core;
import hxext.ds.Maybe;
import lisla.core.tag.StringTag;

class LislaString 
{
	public var data:String;
	public var tag:Maybe<StringTag>;
	
	public inline function new (data:String, ?tag:Maybe<StringTag>) 
	{
		this.data = data;
		this.tag = tag;
	}
}
