package lisla.idl.std.tools.idl;
import lisla.idl.std.entity.idl.TypePath;
import lisla.idl.std.entity.idl.TypeReference;
import lisla.idl.std.entity.idl.TypeReferenceParameterKind;

class TypeReferenceParameterKindTools 
{
    public static inline function mapOverTypeReference(parameter:TypeReferenceParameterKind, func:TypeReference-> TypeReference):TypeReferenceParameterKind
    {
        return switch (parameter)
        {
            case TypeReferenceParameterKind.Type(type):
                TypeReferenceParameterKind.Type(
                    func(type)
                );
                
            case TypeReferenceParameterKind.Dependence(data, type):
                TypeReferenceParameterKind.Dependence(
                    data,
                    func(type)
                );
        }
    }
    
    public static function mapOverTypePath(parameter:TypeReferenceParameterKind, func:TypePath->TypePath):TypeReferenceParameterKind
    {
        return switch (parameter)
        {
            case TypeReferenceParameterKind.Type(type):
                TypeReferenceParameterKind.Type(
                    TypeReferenceTools.mapOverTypePath(type, func)
                );
                
            case TypeReferenceParameterKind.Dependence(value, type):
                TypeReferenceParameterKind.Dependence(
                    value,
                    TypeReferenceTools.mapOverTypePath(type, func)
                );
        }
    }
}