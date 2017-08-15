package lisla.data.tree.core;
import lisla.data.meta.core.MetadataHolder;

interface Tree<LeafType> extends MetadataHolder
{
    public function map<NewLeafType>(func:LeafType-> NewLeafType):Tree<NewLeafType>;
}
