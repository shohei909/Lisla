package arraytree.data.tree.array;

import arraytree.data.meta.core.ArrayWithTag;
import arraytree.data.meta.core.Tag;
import arraytree.data.meta.position.SourceContext;

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

    public function getArrayWithTag():ArrayWithTag<ArrayTree<LeafType>>
    {
        return new ArrayWithTag(data, tag);
    }
}
