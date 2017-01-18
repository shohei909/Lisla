package litll.idl.std.tools.idl;
import haxe.io.Path;
import litll.idl.std.data.idl.EnumConstructor;
import litll.idl.std.data.idl.ParameterizedEnumConstructor;
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
                
            case EnumConstructor.Parameterized(paramerizedConstructor):
                EnumConstructor.Parameterized(
                    new ParameterizedEnumConstructor(
                        paramerizedConstructor.header, 
                        [for (argument in paramerizedConstructor.arguments) TupleArgumentTools.resolveGenericType(argument, parameterContext)]
                    )
                );
        }
    }
}
