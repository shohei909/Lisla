package litll.idl.std.tools.idl;
import litll.idl.std.data.idl.TupleArgument;
import litll.idl.std.data.idl.TypeReference;

class TupleArgumentTools
{
    public static function resolveGenericType(argument:TupleArgument, parameterContext:Map<String, TypeReference>):TupleArgument
    {
        return switch (argument)
        {
            case TupleArgument.Label(_):
                argument;
                
            case TupleArgument.Data(argument):
                TupleArgument.Data(ArgumentTools.resolveGenericType(argument, parameterContext));
        }
    }
}
