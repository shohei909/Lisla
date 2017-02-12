package litll.core;
import litll.core.Litll;
import litll.core.ds.Maybe;
import litll.core.tag.ArrayTag;
import litll.core.tag.StringTag;

class LitllArray<T>
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
    
    public inline function slice(pos:Int, ?end:Int):LitllArray<T>
    {
        return new LitllArray(
            data.slice(pos, end),
            tag
        );
    }
}
