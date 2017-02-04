package litll.idl.std.tools.idl;
import litll.idl.std.data.idl.Argument;
import litll.idl.std.data.idl.TupleElement;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.tools.idl.TypeReferenceTools;

class ArgumentTools 
{
    
    public static function mapOverTypeReference(argument:Argument, func:TypeReference-> TypeReference):Argument
    {
        return new Argument(
            argument.name, 
            func(argument.type), 
            argument.defaultValue
        );
    }
}
