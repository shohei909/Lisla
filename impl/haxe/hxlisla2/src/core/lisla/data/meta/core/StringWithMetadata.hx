package lisla.data.meta.core;

class StringWithMetadata extends MetadataHolderImpl
{
    public var data:String;
    
    public function new(data:String, metadata:Metadata) 
    {
        super(metadata);
        this.data = data;
    }   
}
