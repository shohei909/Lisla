package lisla.data.tree.array;

import lisla.data.meta.core.MaybeTag;
import lisla.data.meta.core.Tag;
import lisla.data.meta.core.WithTag;

@:forward
abstract ArrayTreeDocument<LeafType>(WithTag<ArrayTreeArray<LeafType>>)
{
    public function new(
        data:ArrayTreeArray<LeafType>,
        tag:MaybeTag
    ) 
    {
        this = new WithTag(data, tag);
    }
}
