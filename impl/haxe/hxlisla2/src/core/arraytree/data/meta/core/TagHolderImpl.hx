package arraytree.data.meta.core;
import arraytree.data.meta.core.Tag;

class TagHolderImpl 
{
    public var tag(default, null):Tag;

    public function new(tag:Tag) 
    {
        this.tag = tag;
    }
}