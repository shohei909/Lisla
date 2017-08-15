package lisla.data.tree.al;

enum AlTreeKind<LeafType>
{
    Arr(array:Array<AlTree<LeafType>>);
    Leaf(leaf:LeafType);
}
