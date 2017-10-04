package arraytree.data.tree.ase;
import hxext.ds.OrderedMap;

enum AseTreeKind<LeafType>
{    
    Arr(array:Array<AseTree<LeafType>>);
    Struct(
        map:OrderedMap<String, AseTree<LeafType>>
    );
    Enum(
        label:String,
        parameters:Array<AseTree<LeafType>>
    );
    Leaf(leaf:LeafType);
}
