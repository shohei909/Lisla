package lisla.data.tree.ase;
import hxext.ds.Result;
import lisla.data.meta.core.TagHolderImpl;
import lisla.data.tree.core.Tree;

class AseTree<LeafType> extends TagHolderImpl implements Tree<LeafType>
{
    public var kind(default, null):AseTreeKind<LeafType>;
    
    public function new(kind:AseTreeKind<LeafType>, tag:tag) 
    {
        if (tag == null) throw "test";
        super(tag);
        this.kind = kind;
    }
    
    public function map<NewLeafType>(func:LeafType->NewLeafType):AseTree<NewLeafType>
    {
        return switch (kind)
        {
            case AseTreeKind.Arr(array):
                var kind = [for (element in array) element.map(func)];
                new AseTree(AseTreeKind.Arr(kind), tag.shallowClone());
                
            case AseTreeKind.Enum(label, array):
                var kind = [for (element in array) element.map(func)];
                new AseTree(AseTreeKind.Enum(label, kind), tag.shallowClone());
                
            case AseTreeKind.Leaf(leaf):
                new AseTree(AseTreeKind.Leaf(func(leaf)), tag.shallowClone());
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
                        Result.Ok(new AseTree(AseTreeKind.Arr(ok), tag.shallowClone()));
                        
                    case Result.Error(errors):
                        Result.Error(errors);
                }
                
            case AseTreeKind.Leaf(leaf):
                switch (func(leaf))
                {
                    case Result.Ok(ok):
                        Result.Ok(new AseTree(AseTreeKind.Leaf(ok), tag.shallowClone()));
                        
                    case Result.Error(errors):
                        var range = OptionTools.getOrElse(tag.range, Range.zero());
                        Result.Error([for (error in errors) new DataWithRange(error, range)]);
                }
        }
    }
}
