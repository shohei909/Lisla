package lisla.data.tree.array;

import lisla.data.meta.core.ArrayWithMetadata;
import lisla.data.meta.core.Metadata;
import lisla.data.meta.position.SourceContext;

class ArrayTreeDocument<LeafType>
{   
    public var data(default, null):Array<ArrayTree<LeafType>>;
    public var context(default, null):SourceContext;
    public var metadata(default, null):Metadata;

    public function new(
        data:Array<ArrayTree<LeafType>>,
        context:SourceContext,
        metadata:Metadata
    ) 
    {
        this.metadata = metadata;
        this.context = context;
        this.data = data;
    }

    public function getArrayWithMetadata():ArrayWithMetadata<ArrayTree<LeafType>>
    {
        return new ArrayWithMetadata(data, metadata);
    }    
}
