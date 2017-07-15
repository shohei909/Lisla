package lisla.data.leaf.template;

class Placeholder
{
    public var argument:String;
    
    public function new(argument:String)
    {
        this.argument = argument;
    }
    
    public function getUnbindedArgmentNames():Array<String>
    {
        return [argument];
    }
}
