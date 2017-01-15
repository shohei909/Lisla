package litll.idl.std.tools.idl;
import litll.idl.std.data.idl.EnumConstructor;
import litll.idl.std.data.idl.TupleArgument;
import litll.idl.std.data.idl.TypeReference;

class EnumConstructorTools 
{
    public static function resolveGenericType(constructor:EnumConstructor, parameterContext:Map<String, TypeReference>):EnumConstructor
    {
        return switch (constructor)
        {
            case EnumConstructor.Primitive(_):
                constructor;
                
            case EnumConstructor.Parameterized(name, arguments):
                EnumConstructor.Parameterized(
                    name, 
                    [for (argument in arguments) TupleArgumentTools.resolveGenericType(argument, parameterContext)]
                );
        }
    }
}
