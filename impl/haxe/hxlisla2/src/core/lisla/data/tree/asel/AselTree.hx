package lisla.data.tree.asel;
import hxext.ds.Result;
import lisla.data.meta.core.MetadataHolderImpl;
import lisla.data.tree.core.Tree;

class AselTree<LeafType> extends MetadataHolderImpl implements Tree<LeafType>
{
    public var kind(default, null):AselTreeKind<LeafType>;
    
    public function new(kind:AselTreeKind<LeafType>, metadata:Metadata) 
    {
        if (metadata == null) throw "test";
        super(metadata);
        this.kind = kind;
    }
    
    public function map<NewLeafType>(func:LeafType->NewLeafType):AselTree<NewLeafType>
    {
        return switch (kind)
        {
            case AselTreeKind.Arr(array):
                var kind = [for (element in array) element.map(func)];
                new AselTree(AselTreeKind.Arr(kind), metadata.shallowClone());
                
            case AselTreeKind.Enum(label, array):
                var kind = [for (element in array) element.map(func)];
                new AselTree(AselTreeKind.Enum(label, kind), metadata.shallowClone());
                
            case AselTreeKind.Leaf(leaf):
                new AselTree(AselTreeKind.Leaf(func(leaf)), metadata.shallowClone());
        }
    }
    
    public function mapOrError<NewLeafType, ErrorType>(
        func:LeafType->Result<NewLeafType, Array<ErrorType>>,
        persevering:Bool
    ):Result<AselTree<NewLeafType>, Array<DataWithRange<ErrorType>>>
    {
        return switch (kind)
        {
            case AselTreeKind.Arr(array):
                switch (AselTreeArrayTools.mapOrError(array, func, persevering))
                {
                    case Result.Ok(ok):
                        Result.Ok(new AselTree(AselTreeKind.Arr(ok), metadata.shallowClone()));
                        
                    case Result.Error(errors):
                        Result.Error(errors);
                }
                
            case AselTreeKind.Leaf(leaf):
                switch (func(leaf))
                {
                    case Result.Ok(ok):
                        Result.Ok(new AselTree(AselTreeKind.Leaf(ok), metadata.shallowClone()));
                        
                    case Result.Error(errors):
                        var range = OptionTools.getOrElse(metadata.range, Range.zero());
                        Result.Error([for (error in errors) new DataWithRange(error, range)]);
                }
        }
    }
}
