package lisla.data.tree.ase;
import hxext.ds.Result;
import lisla.data.meta.core.MetadataHolderImpl;
import lisla.data.tree.core.Tree;

class AseTree<LeafType> extends MetadataHolderImpl implements Tree<LeafType>
{
    public var kind(default, null):AseTreeKind<LeafType>;
    
    public function new(kind:AseTreeKind<LeafType>, metadata:Metadata) 
    {
        if (metadata == null) throw "test";
        super(metadata);
        this.kind = kind;
    }
    
    public function map<NewLeafType>(func:LeafType->NewLeafType):AseTree<NewLeafType>
    {
        return switch (kind)
        {
            case AseTreeKind.Arr(array):
                var kind = [for (element in array) element.map(func)];
                new AseTree(AseTreeKind.Arr(kind), metadata.shallowClone());
                
            case AseTreeKind.Enum(label, array):
                var kind = [for (element in array) element.map(func)];
                new AseTree(AseTreeKind.Enum(label, kind), metadata.shallowClone());
                
            case AseTreeKind.Leaf(leaf):
                new AseTree(AseTreeKind.Leaf(func(leaf)), metadata.shallowClone());
        }
    }
    
    public function mapOrError<NewLeafType, ErrorType>(
        func:LeafType->Result<NewLeafType, Array<ErrorType>>,
        persevering:Bool
    ):Result<AseTree<NewLeafType>, Array<DataWithRange<ErrorType>>>
    {
        return switch (kind)
        {
            case AseTreeKind.Arr(array):
                switch (AselTreeArrayTools.mapOrError(array, func, persevering))
                {
                    case Result.Ok(ok):
                        Result.Ok(new AseTree(AseTreeKind.Arr(ok), metadata.shallowClone()));
                        
                    case Result.Error(errors):
                        Result.Error(errors);
                }
                
            case AseTreeKind.Leaf(leaf):
                switch (func(leaf))
                {
                    case Result.Ok(ok):
                        Result.Ok(new AseTree(AseTreeKind.Leaf(ok), metadata.shallowClone()));
                        
                    case Result.Error(errors):
                        var range = OptionTools.getOrElse(metadata.range, Range.zero());
                        Result.Error([for (error in errors) new DataWithRange(error, range)]);
                }
        }
    }
}
