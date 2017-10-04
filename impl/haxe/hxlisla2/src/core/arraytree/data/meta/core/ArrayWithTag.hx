package arraytree.data.meta.core;

class ArrayWithTag<ElementType> extends TagHolderImpl
{
    public var data:Array<ElementType>;
    
    public function new(data:Array<ElementType>, tag:Tag) 
    {
        super(tag);
        this.data = data;
    }
}
