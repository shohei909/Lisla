package lisla.data.tree.array;
import hxext.ds.OptionTools;
import hxext.ds.Result;
import lisla.data.meta.position.CodePointIndex;
import lisla.data.meta.position.DataWithRange;
import lisla.data.meta.position.Range;
import lisla.data.tree.array.ArrayTreeKind;
import lisla.data.meta.core.Metadata;
import lisla.data.meta.core.MetadataHolderImpl;
import lisla.data.tree.core.Tree;

class ArrayTree<LeafType> extends MetadataHolderImpl implements Tree<LeafType>
{
    public var kind(default, null):ArrayTreeKind<LeafType>;
    
    public function new(kind:ArrayTreeKind<LeafType>, metadata:Metadata) 
    {
        super(metadata);
        this.kind = kind;
    }
    
    public function map<NewLeafType>(func:LeafType->NewLeafType):ArrayTree<NewLeafType>
    {
        return switch (kind)
        {
            case ArrayTreeKind.Arr(array):
                var kind = [for (element in array) element.map(func)];
                new ArrayTree(ArrayTreeKind.Arr(kind), metadata.shallowClone());
                
            case ArrayTreeKind.Leaf(leaf):
                new ArrayTree(ArrayTreeKind.Leaf(func(leaf)), metadata.shallowClone());
        }
    }
    
    public function mapOrError<NewLeafType, ErrorType>(
        func:LeafType->Result<NewLeafType, Array<ErrorType>>,
        persevering:Bool
    ):Result<ArrayTree<NewLeafType>, Array<DataWithRange<ErrorType>>>
    {
        return switch (kind)
        {
            case ArrayTreeKind.Arr(array):
                switch (ArrayTreeArrayTools.mapOrError(array, func, persevering))
                {
                    case Result.Ok(ok):
                        Result.Ok(new ArrayTree(ArrayTreeKind.Arr(ok), metadata.shallowClone()));
                        
                    case Result.Error(errors):
                        Result.Error(errors);
                }
                
            case ArrayTreeKind.Leaf(leaf):
                switch (func(leaf))
                {
                    case Result.Ok(ok):
                        Result.Ok(new ArrayTree(ArrayTreeKind.Leaf(ok), metadata.shallowClone()));
                        
                    case Result.Error(errors):
                        var range = OptionTools.getOrElse(metadata.range, Range.zero());
                        Result.Error([for (error in errors) new DataWithRange(error, range)]);
                }
        }
    }
}
