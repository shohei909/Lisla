package lisla.data.tree.array;

import lisla.data.meta.core.ArrayWithMetadata;
import lisla.data.meta.core.BlockData;
import lisla.data.meta.core.Metadata;
import lisla.data.meta.position.SourceMap;

class ArrayTreeBlock<LeafType> extends BlockData<Array<ArrayTree<LeafType>>>
{   
    public function new(
        data:Array<ArrayTree<LeafType>>,
        metadata:Metadata,
        sourceMap:SourceMap
    ) 
    {
        super(data, metadata, sourceMap);
    }
    
    public function getArrayWithMetadata():ArrayWithMetadata<ArrayTree<LeafType>>
    {
        return new ArrayWithMetadata(data, metadata);
    }
}
