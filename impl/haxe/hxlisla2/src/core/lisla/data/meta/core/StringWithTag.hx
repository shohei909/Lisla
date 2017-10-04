package lisla.data.meta.core;

class StringWithTag extends TagHolderImpl
{
    public var data:String;
    
    public function new(data:String, tag:Tag) 
    {
        super(tag);
        this.data = data;
    }   
}
