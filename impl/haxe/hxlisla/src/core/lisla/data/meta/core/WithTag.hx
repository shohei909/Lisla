package lisla.data.meta.core;
import hxext.ds.Maybe;
import lisla.data.meta.core.MaybeTag;

@:forward(data, tag)
abstract WithTag<T>(WithTagImpl<T>) from WithTagImpl<T>
{
    public function new(data:Null<T>, ?tag:MaybeTag)
    {
        this = new WithTagImpl(data, tag);
    }
    
    @:from static public function fromData<T>(data:T):WithTag<T>
    {
        return new WithTag(data, Maybe.none());
    }
    
    @:from static public function from<T>(value:WithTagImpl<T>):WithTag<T>
    {
        return value;
    }
    
    public static function empty<T>(?tag:MaybeTag):WithTag<T>
    {
        return new WithTag(null, tag);
    }
    
    public function isEmpty():Bool
    {
        return this.data == null;
    }
    
    public inline function map<U>(func:T->U):WithTag<U>
    {
        return convert(func(this.data));
    }
    
    public inline function convert<U>(value:U):WithTag<U>
    {
        return new WithTag(value, this.tag);
    }
}

private class WithTagImpl<T>
{
    public var data:T;
    public var tag:MaybeTag;
    
    public inline function new(data:T, tag:MaybeTag) 
    {
        this.data = data;
        this.tag = tag;
    }
}
