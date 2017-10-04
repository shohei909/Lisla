package arraytree.data.tree.array;
import hxext.ds.OptionTools;
import hxext.ds.Result;
import arraytree.data.meta.core.ArrayWithTag;
import arraytree.data.meta.core.Tag;
import arraytree.data.meta.core.TagHolderImpl;
import arraytree.data.meta.core.StringWithTag;
import arraytree.data.meta.position.Range;
import arraytree.data.tree.array.ArrayTreeArrayTools;
import arraytree.data.tree.array.ArrayTreeKind;
import arraytree.data.tree.core.Tree;

class ArrayTree<LeafType> extends TagHolderImpl implements Tree<LeafType>
{
    public var kind(default, null):ArrayTreeKind<LeafType>;
    
    public function new(kind:ArrayTreeKind<LeafType>, tag:Tag) 
    {
        if (tag == null) throw "test";
        super(tag);
        this.kind = kind;
    }
    
    public function map<NewLeafType>(func:LeafType->Dynamic):ArrayTree<NewLeafType>
    {
        return switch (kind)
        {
            case ArrayTreeKind.Arr(array):
                var kind = [for (element in array) element.map(func)];
                new ArrayTree(ArrayTreeKind.Arr(kind), tag.shallowClone());
                
            case ArrayTreeKind.Leaf(leaf):
                new ArrayTree(ArrayTreeKind.Leaf(func(leaf)), tag.shallowClone());
        }
    }
    
    public function mapOrError<NewLeafType, ErrorType>(
        func:LeafType->Tag->Result<NewLeafType, Array<ErrorType>>,
        persevering:Bool
    ):Result<ArrayTree<NewLeafType>, Array<ErrorType>>
    {
        return switch (kind)
        {
            case ArrayTreeKind.Arr(array):
                switch (ArrayTreeArrayTools.mapOrError(array, func, persevering))
                {
                    case Result.Ok(ok):
                        Result.Ok(new ArrayTree(ArrayTreeKind.Arr(ok), tag.shallowClone()));
                        
                    case Result.Error(errors):
                        Result.Error(errors);
                }
                
            case ArrayTreeKind.Leaf(leaf):
                switch (func(leaf, tag))
                {
                    case Result.Ok(ok):
                        Result.Ok(new ArrayTree(ArrayTreeKind.Leaf(ok), tag.shallowClone()));
                        
                    case Result.Error(errors):
                        Result.Error(errors);
                }
        }
    }
    
    public static function fromArray<T>(array:ArrayWithTag<ArrayTree<T>>):ArrayTree<T>
    {
        return new ArrayTree(
            ArrayTreeKind.Arr(array.data),
            array.tag
        );
    }
    
    public static function fromString(string:StringWithTag):ArrayTree<String>
    {
        return new ArrayTree(
            ArrayTreeKind.Leaf(string.data),
            string.tag
        );
    }
}
