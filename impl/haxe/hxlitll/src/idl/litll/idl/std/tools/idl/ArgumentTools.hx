package litll.idl.std.tools.idl;
import litll.idl.std.data.idl.Argument;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.tools.idl.TypeReferenceTools;

class ArgumentTools 
{
    public static function resolveGenericType(argument:Argument, parameterContext:Map<String, TypeReference>):Argument
    {
        return new Argument(
            argument.name, 
            TypeReferenceTools.resolveGenericType(argument.type, parameterContext), 
            argument.defaultValue
        );
    }
}
