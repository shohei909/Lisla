package litll.idl.std.tools.idl;
import litll.idl.std.data.idl.StructField;
import litll.idl.std.data.idl.TypeReference;

class StructFieldTools 
{
    public static function resolveGenericType(field:StructField, parameterContext:Map<String, TypeReference>):StructField
    {
        return switch field
        {
            case StructField.Field(header, type):
                StructField.Field(
                    header, 
                    TypeReferenceTools.resolveGenericType(type, parameterContext)
                );
                
            case StructField.Boolean(_):
                field;
        }
    }
}
