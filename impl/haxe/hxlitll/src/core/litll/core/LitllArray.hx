package lisla.core;
import lisla.core.Lisla;
import hxext.ds.Maybe;
import lisla.core.tag.ArrayTag;
import lisla.core.tag.StringTag;

class LislaArray<T>
{
	public var data:Array<T>;
	public var tag:Maybe<ArrayTag>;
	
    public var length(get, never):Int;
    private inline function get_length():Int
    {
        return data.length;
    }
    
	public inline function new (data:Array<T>, ?tag:Maybe<ArrayTag>):Void 
	{
		this.data = data;
		this.tag = tag;
	}
    
    public inline function slice(pos:Int, ?end:Int):LislaArray<T>
    {
        return new LislaArray(
            data.slice(pos, end),
            tag
        );
    }
}
