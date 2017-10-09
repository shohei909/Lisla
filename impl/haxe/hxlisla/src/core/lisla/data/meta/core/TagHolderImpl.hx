package lisla.data.meta.core;
import lisla.data.meta.core.Tag;

class TagHolderImpl 
{
    public var tag(default, null):MaybeTag;

    public function new(tag:MaybeTag) 
    {
        this.tag = tag;
    }
}