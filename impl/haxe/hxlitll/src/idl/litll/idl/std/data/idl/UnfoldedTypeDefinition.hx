package litll.idl.std.data.idl;
import litll.idl.std.data.idl.Argument;
import litll.idl.std.data.idl.EnumConstructor;
import litll.idl.std.data.idl.TupleElement;

enum UnfoldedTypeDefinition
{
    Arr(elementType:TypeReference);
    Str;
    Enum(constuctors:Array<EnumConstructor>);
    Tuple(arguments:Array<TupleElement>);
    Struct(arguments:Array<StructElement>);
}
