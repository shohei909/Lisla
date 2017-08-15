package lisla.data.meta.core;

class ArrayWithMetadata<ElementType> extends MetadataHolderImpl
{
    public var data:Array<ElementType>;
    
    public function new(data:Array<ElementType>, metadata:Metadata) 
    {
        super(metadata);
        this.data = data;
    }
}
