package lisla.data.tree.al;

import lisla.data.meta.core.ArrayWithMetadata;
import lisla.data.meta.core.BlockData;
import lisla.data.meta.core.Metadata;
import lisla.data.meta.position.SourceMap;

class AlTreeBlock<LeafType> extends BlockData<Array<AlTree<LeafType>>>
{   
    public function new(
        data:Array<AlTree<LeafType>>,
        metadata:Metadata,
        sourceMap:SourceMap
    ) 
    {
        super(data, metadata, sourceMap);
    }
    
    public function getArrayWithMetadata():ArrayWithMetadata<AlTree<LeafType>>
    {
        return new ArrayWithMetadata(data, metadata);
    }
}
