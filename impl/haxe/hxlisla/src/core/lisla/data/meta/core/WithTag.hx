package lisla.data.meta.core;
import hxext.ds.Maybe;

@:forward(data, tag)
abstract WithTag<T>(WithTagImpl<T>) 
{
    public function new(data:T, tag:Maybe<Tag>)
    {
        this = new WithTagImpl(data, tag);
    }
    
    @:from static public function fromData<T>(data:T):WithTag<T>
    {
        return new WithTag(data, Maybe.none());
    }
    
    @:from static public function from<T>(data:WithTag<T>):WithTag<T>
    {
        return data;
    }
}

private class WithTagImpl<T>
{
    public var data:T;
    public var tag:Maybe<Tag>;
    
    public function new(data:T, tag:Maybe<Tag>) 
    {
        this.data = data;
        this.tag = tag;
    }
}
