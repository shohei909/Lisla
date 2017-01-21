package litll.idl.std.tools.idl;
import litll.idl.std.data.idl.EnumConstructor;
import litll.idl.std.data.idl.ParameterizedEnumConstructor;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.delitllfy.idl.ParameterizedEnumConstructorDelitllfier;

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
                        paramerizedConstructor.name, 
                        [for (element in paramerizedConstructor.elements) TupleElementTools.resolveGenericType(element, parameterContext)]
                    )
                );
        }
    }
}
