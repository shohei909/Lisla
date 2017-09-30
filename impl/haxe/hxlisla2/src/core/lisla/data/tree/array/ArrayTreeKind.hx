package lisla.data.tree.array;

enum ArrayTreeKind<LeafType>
{
    Arr(array:Array<ArrayTree<LeafType>>);
    Leaf(leaf:LeafType);
}
