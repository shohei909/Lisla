package lisla.data.tree.array;
import hxext.ds.Result;
import lisla.data.meta.core.MaybeTag;
import lisla.data.meta.core.WithTag;

class ArrayTreeTools 
{
    public static function mapOrError<LeafType, NewLeafType, ErrorType>
    (
        tree:WithTag<ArrayTree<LeafType>>,
        func:LeafType->MaybeTag->Result<NewLeafType, Array<ErrorType>>,
        persevering:Bool
    ):Result<WithTag<ArrayTree<NewLeafType>>, Array<ErrorType>>
    {
        return switch (tree.data)
        {
            case ArrayTree.Arr(array):
                switch (ArrayTreeArrayTools.mapOrError(array, func, persevering))
                {
                    case Result.Ok(ok):
                        Result.Ok(
                            tree.convert(ArrayTree.Arr(ok))
                        );
                        
                    case Result.Error(errors):
                        Result.Error(errors);
                }
                
            case ArrayTree.Leaf(leaf):
                switch (func(leaf, tree.tag))
                {
                    case Result.Ok(ok):
                        Result.Ok(tree.convert(ArrayTree.Leaf(ok)));
                        
                    case Result.Error(errors):
                        Result.Error(errors);
                }
        }
    }
}