package litll.idl.std.data.idl;
import litll.idl.std.data.idl.Argument;
import litll.idl.std.data.idl.EnumConstructor;
import litll.idl.std.data.idl.TupleArgument;

enum UnfoldedTypeDefinition
{
    Arr(elementType:TypeReference);
    Str;
    Enum(constuctors:Array<EnumConstructor>);
    Tuple(arguments:Array<TupleArgument>);
    Struct(arguments:Array<Argument>);
}
