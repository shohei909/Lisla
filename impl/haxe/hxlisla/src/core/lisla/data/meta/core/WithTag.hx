package lisla.data.meta.core;

class WithTag<T>
{
    public var data:T;
    public var tag:Tag;
    
    public function new(data:T, tag:Tag) 
    {
        this.data = data;
        this.tag = tag;
    }
}
