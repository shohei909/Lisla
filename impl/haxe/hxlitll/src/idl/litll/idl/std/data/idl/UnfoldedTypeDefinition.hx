package litll.idl.std.data.idl;
import litll.idl.std.data.idl.Argument;
import litll.idl.std.data.idl.EnumConstructor;
import litll.idl.std.data.idl.TupleElement;

enum UnfoldedTypeDefinition
{
    Arr(elementType:TypeReference);
    Str;
    Enum(constuctors:Array<EnumConstructor>);
    Tuple(elements:Array<TupleElement>);
    Struct(elements:Array<StructElement>);
}
