package lisla.data.tree.array;

import lisla.data.meta.core.Tag;
import lisla.data.meta.core.WithTag;

class ArrayTreeDocument<LeafType>
{   
    public var data(default, null):Array<ArrayTree<LeafType>>;
    public var tag(default, null):Tag;

    public function new(
        data:Array<ArrayTree<LeafType>>,
        tag:Tag
    ) 
    {
        this.tag = tag;
        this.data = data;
    }

    public function getArrayWithTag():WithTag<Array<ArrayTree<LeafType>>>
    {
        return new WithTag(data, tag);
    }
}
