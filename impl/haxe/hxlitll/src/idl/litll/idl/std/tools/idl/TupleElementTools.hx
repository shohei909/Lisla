package litll.idl.std.tools.idl;
import litll.idl.std.data.idl.TupleElement;
import litll.idl.std.data.idl.TypeReference;

class TupleElementTools
{
    public static function resolveGenericType(element:TupleElement, parameterContext:Map<String, TypeReference>):TupleElement
    {
        return switch (element)
        {
            case TupleElement.Label(_):
                element;
                
            case TupleElement.Data(element):
                TupleElement.Data(ArgumentTools.resolveGenericType(element, parameterContext));
        }
    }
}
