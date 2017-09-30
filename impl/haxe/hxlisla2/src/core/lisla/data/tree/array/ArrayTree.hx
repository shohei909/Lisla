package lisla.data.tree.array;
import hxext.ds.OptionTools;
import hxext.ds.Result;
import lisla.data.meta.core.ArrayWithMetadata;
import lisla.data.meta.core.Metadata;
import lisla.data.meta.core.MetadataHolderImpl;
import lisla.data.meta.core.StringWithMetadata;
import lisla.data.meta.position.Range;
import lisla.data.tree.array.ArrayTreeArrayTools;
import lisla.data.tree.array.ArrayTreeKind;
import lisla.data.tree.core.Tree;

class ArrayTree<LeafType> extends MetadataHolderImpl implements Tree<LeafType>
{
    public var kind(default, null):ArrayTreeKind<LeafType>;
    
    public function new(kind:ArrayTreeKind<LeafType>, metadata:Metadata) 
    {
        if (metadata == null) throw "test";
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
        func:LeafType->Metadata->Result<NewLeafType, Array<ErrorType>>,
        persevering:Bool
    ):Result<ArrayTree<NewLeafType>, Array<ErrorType>>
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
                switch (func(leaf, metadata))
                {
                    case Result.Ok(ok):
                        Result.Ok(new ArrayTree(ArrayTreeKind.Leaf(ok), metadata.shallowClone()));
                        
                    case Result.Error(errors):
                        Result.Error(errors);
                }
        }
    }
    
    public static function fromArray<T>(array:ArrayWithMetadata<ArrayTree<T>>):ArrayTree<T>
    {
        return new ArrayTree(
            ArrayTreeKind.Arr(array.data),
            array.metadata
        );
    }
    
    public static function fromString(string:StringWithMetadata):ArrayTree<String>
    {
        return new ArrayTree(
            ArrayTreeKind.Leaf(string.data),
            string.metadata
        );
    }
}
