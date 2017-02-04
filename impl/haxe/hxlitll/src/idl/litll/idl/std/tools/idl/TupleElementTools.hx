package litll.idl.std.tools.idl;
import litll.idl.std.data.idl.TupleElement;
import litll.idl.std.data.idl.TypeReference;

class TupleElementTools
{
    public static function mapOverTypeReference(element:TupleElement, func:TypeReference->TypeReference):TupleElement
    {
        return switch (element)
        {
            case TupleElement.Label(_):
                element;
                
            case TupleElement.Argument(argument):
                TupleElement.Argument(ArgumentTools.mapOverTypeReference(argument, func));
        }
    }
    
    public static function iterateOverTypeReference(element:TupleElement, func:TypeReference-> Void):Void
    {
        switch (element)
        {
            case TupleElement.Label(_):
                // nothing to do
                
            case TupleElement.Argument(argument):
                func(argument.type);
        }
    }
}
