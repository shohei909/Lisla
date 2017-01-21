package litll.idl.std.tools.idl;
import haxe.ds.Option;
import litll.core.ds.Maybe;
import litll.idl.exception.IdlException;
import litll.idl.std.data.idl.EnumConstructor;
import litll.idl.std.data.idl.TupleElement;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.data.idl.TypeReferenceParameter;
import litll.idl.std.data.idl.TypeReferenceParameterKind;

class TypeReferenceParameterTools 
{
    public static function resolveGenericType(parameter:TypeReferenceParameter, parameterContext:Map<String, TypeReference>):TypeReferenceParameter
    {
        var processedValue = switch (parameter.processedValue.toOption())
        {
            case Option.None:
                Maybe.none();
                
            case Option.Some(TypeReferenceParameterKind.Dependence(type)):
                Maybe.some(TypeReferenceParameterKind.Dependence(TypeReferenceTools.resolveGenericType(type, parameterContext)));
                
            case Option.Some(TypeReferenceParameterKind.Type(type)):
                Maybe.some(TypeReferenceParameterKind.Type(TypeReferenceTools.resolveGenericType(type, parameterContext)));
        }
        
        var result = new TypeReferenceParameter(parameter.value);
        result.processedValue = processedValue;
        return result;
    }
    
    public static function getTypeParameters(parameters:Array<TypeReferenceParameter>):Array<TypeReference>
    {
        var result = [];
        for (parameter in parameters)
        {
            switch (parameter.processedValue.toOption())
            {
                case Option.None:
                    throw new IdlException("must be processed: " + parameter.toString());
                    
                case Option.Some(TypeReferenceParameterKind.Dependence(type)):
                    // skip
                    
                case Option.Some(TypeReferenceParameterKind.Type(type)):
                    result.push(type);
            }
        }
        
        return result;
    }
}
