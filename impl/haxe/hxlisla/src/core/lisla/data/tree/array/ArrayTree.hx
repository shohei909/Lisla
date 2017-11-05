package lisla.data.tree.array;
import lisla.data.meta.core.WithTag;

enum ArrayTree<LeafType>
{
    Arr(array:ArrayTreeArray<LeafType>);
    Leaf(leaf:LeafType);
}
