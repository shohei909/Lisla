package lisla.data.tree.asel;
import hxext.ds.OrderedMap;

enum AselTreeKind<LeafType>
{    
    Arr(array:Array<AselTree<LeafType>>);
    Struct(
        map:OrderedMap<String, AselTree<LeafType>>
    );
    Enum(
        label:String,
        parameters:Array<AselTree<LeafType>>
    );
    Leaf(leaf:LeafType);
}
