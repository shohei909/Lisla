package lisla.data.tree.array;
import hxext.ds.Result;
import lisla.data.meta.core.MaybeTag;
import lisla.data.meta.core.Tag;
import lisla.data.meta.core.TagHolderImpl;
import lisla.data.meta.core.WithTag;
import lisla.data.tree.array.ArrayTreeArrayTools;
import lisla.data.tree.array.ArrayTreeKind;
import lisla.data.tree.core.Tree;

class ArrayTree<LeafType> extends TagHolderImpl implements Tree<LeafType>
{
    public var kind(default, null):ArrayTreeKind<LeafType>;
    
    public function new(kind:ArrayTreeKind<LeafType>, tag:MaybeTag) 
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
        func:LeafType->MaybeTag->Result<NewLeafType, Array<ErrorType>>,
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
    
    public static function fromArray<T>(array:WithTag<Array<ArrayTree<T>>>):ArrayTree<T>
    {
        return new ArrayTree(
            ArrayTreeKind.Arr(array.data),
            array.tag
        );
    }
    
    public static function fromString(string:WithTag<String>):ArrayTree<String>
    {
        return new ArrayTree(
            ArrayTreeKind.Leaf(string.data),
            string.tag
        );
    }
}
