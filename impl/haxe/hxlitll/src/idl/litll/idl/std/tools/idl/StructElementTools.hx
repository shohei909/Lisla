package litll.idl.std.tools.idl;
import litll.idl.std.data.idl.StructElement;
import litll.idl.std.data.idl.StructField;
import litll.idl.std.data.idl.TypeReference;

class StructElementTools 
{
    public static function resolveGenericType(element:StructElement, parameterContext:Map<String, TypeReference>):StructElement
    {
        return switch (element)
        {
            case StructElement.Field(field):
                StructElement.Field(
                    new StructField(
                        field.name, 
                        TypeReferenceTools.resolveGenericType(field.type, parameterContext),
                        field.defaultValue
                    )
                );
                
            case StructElement.Label(_) | StructElement.NestedLabel(_):
                element;
        }
    }
}
