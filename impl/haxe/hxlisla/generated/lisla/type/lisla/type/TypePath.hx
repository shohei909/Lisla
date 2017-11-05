package lisla.type.lisla.type;

abstract TypePath(String)
{
    public var value(get, never):String; 
    private function get_value():String {
        return this;
    }

    public function new(value:String) 
    {
        // TODO: Validation
        this = value;
    }
    
    public function getName():TypeName
    {
        return new TypeName(this.split(".").pop());
    }
}
