package lisla.data.meta.core;
import lisla.data.meta.core.Metadata;

class MetadataHolderImpl 
{
    public var metadata(default, null):Metadata;

    public function new(metadata:Metadata) 
    {
        this.metadata = metadata;
    }
}