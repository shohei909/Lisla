package litll.idl.std.tools.idl;
import haxe.ds.Option;
import hxext.ds.Maybe;
import litll.idl.exception.IdlException;
import litll.idl.std.entity.idl.TypePath;
import litll.idl.std.entity.idl.TypeReference;
import litll.idl.std.entity.idl.TypeReferenceDependenceKind;
import litll.idl.std.entity.idl.TypeReferenceParameter;
import litll.idl.std.entity.idl.TypeReferenceParameterKind;

class TypeReferenceParameterTools 
{
    public static function getTypeParameters(parameters:Array<TypeReferenceParameter>):Array<TypeReference>
    {
        var result = [];
        for (parameter in parameters)
        {
            switch (parameter.processedValue.toOption())
            {
                case Option.None:
                    throw new IdlException("must be processed: " + parameter.toString());
                    
                case Option.Some(TypeReferenceParameterKind.Dependence(_)):
                    // skip
                    
                case Option.Some(TypeReferenceParameterKind.Type(type)):
                    result.push(type);
            }
        }
        
        return result;
    }
    
    public static function mapOverTypePath(parameter:TypeReferenceParameter, func:TypePath->TypePath):TypeReferenceParameter
    {
        var processedValue = switch (parameter.processedValue.toOption())
        {
            case Option.None:
                Maybe.none();
                
            case Option.Some(data):
                Maybe.some(TypeReferenceParameterKindTools.mapOverTypePath(data, func));
        }
        
        var result = new TypeReferenceParameter(parameter.value);
        result.processedValue = processedValue;
        return result;
    }
    
    public static inline function mapOverTypeReference(parameter:TypeReferenceParameter, func:TypeReference->TypeReference):TypeReferenceParameter
    {
        var processedValue = switch (parameter.processedValue.toOption())
        {
            case Option.None:
                Maybe.none();
                
            case Option.Some(data):
                Maybe.some(TypeReferenceParameterKindTools.mapOverTypeReference(data, func));
        }
        
        var result = new TypeReferenceParameter(parameter.value);
        result.processedValue = processedValue;
        return result;
    }
    
    public static function specialize(parameter:TypeReferenceParameter, typeMap:Map<String, TypeReference>, dependenceMap:Map<String, TypeReferenceDependenceKind>):TypeReferenceParameter
    {
        var processedValue = switch (parameter.processedValue.toOption())
        {
            case Option.None:
                Maybe.none();
                
            case Option.Some(TypeReferenceParameterKind.Type(type)):
                var kind = TypeReferenceParameterKind.Type(TypeReferenceTools.specialize(type, typeMap, dependenceMap));
                Maybe.some(kind);
                
            case Option.Some(TypeReferenceParameterKind.Dependence(data, type)):
                var kind = TypeReferenceParameterKind.Dependence(
                    switch (data)
                    {
                        case TypeReferenceDependenceKind.Reference(name):
                            if (dependenceMap.exists(name)) dependenceMap[name] else data; 
                            
                        case TypeReferenceDependenceKind.Const(value):
                            data;
                    },
                    TypeReferenceTools.specialize(type, typeMap, dependenceMap)
                );
                Maybe.some(kind);
        }
        
        var result = new TypeReferenceParameter(parameter.value);
        result.processedValue = processedValue;
        return result;
    }
}
