package litll.idl.std.data.idl;

enum UnfoldedTypeDefinition
{
    Arr(elementType:TypeReference);
    Str;
    Enum(constuctors:Array<EnumConstructor>);
    Tuple(arguments:Array<TupleArgument>);
    Struct(arguments:Array<Argument>);
}
