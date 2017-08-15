package lisla.data.tree.al;
import hxext.ds.OptionTools;
import hxext.ds.Result;
import lisla.data.meta.core.ArrayWithMetadata;
import lisla.data.meta.core.Metadata;
import lisla.data.meta.core.MetadataHolderImpl;
import lisla.data.meta.core.StringWithMetadata;
import lisla.data.meta.position.Range;
import lisla.data.tree.al.AlTreeArrayTools;
import lisla.data.tree.al.AlTreeKind;
import lisla.data.tree.core.Tree;

class AlTree<LeafType> extends MetadataHolderImpl implements Tree<LeafType>
{
    public var kind(default, null):AlTreeKind<LeafType>;
    
    public function new(kind:AlTreeKind<LeafType>, metadata:Metadata) 
    {
        if (metadata == null) throw "test";
        super(metadata);
        this.kind = kind;
    }
    
    public function map<NewLeafType>(func:LeafType->NewLeafType):AlTree<NewLeafType>
    {
        return switch (kind)
        {
            case AlTreeKind.Arr(array):
                var kind = [for (element in array) element.map(func)];
                new AlTree(AlTreeKind.Arr(kind), metadata.shallowClone());
                
            case AlTreeKind.Leaf(leaf):
                new AlTree(AlTreeKind.Leaf(func(leaf)), metadata.shallowClone());
        }
    }
    
    public function mapOrError<NewLeafType, ErrorType>(
        func:LeafType->Metadata->Result<NewLeafType, Array<ErrorType>>,
        persevering:Bool
    ):Result<AlTree<NewLeafType>, Array<ErrorType>>
    {
        return switch (kind)
        {
            case AlTreeKind.Arr(array):
                switch (AlTreeArrayTools.mapOrError(array, func, persevering))
                {
                    case Result.Ok(ok):
                        Result.Ok(new AlTree(AlTreeKind.Arr(ok), metadata.shallowClone()));
                        
                    case Result.Error(errors):
                        Result.Error(errors);
                }
                
            case AlTreeKind.Leaf(leaf):
                switch (func(leaf, metadata))
                {
                    case Result.Ok(ok):
                        Result.Ok(new AlTree(AlTreeKind.Leaf(ok), metadata.shallowClone()));
                        
                    case Result.Error(errors):
                        Result.Error(errors);
                }
        }
    }
    
    public static function fromArray<T>(array:ArrayWithMetadata<AlTree<T>>):AlTree<T>
    {
        return new AlTree(
            AlTreeKind.Arr(array.data),
            array.metadata
        );
    }
    
    public static function fromString(string:StringWithMetadata):AlTree<String>
    {
        return new AlTree(
            AlTreeKind.Leaf(string.data),
            string.metadata
        );
    }
}
