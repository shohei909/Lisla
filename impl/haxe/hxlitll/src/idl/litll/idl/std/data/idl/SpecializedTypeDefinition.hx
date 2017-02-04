package litll.idl.std.data.idl;

enum SpecializedTypeDefinition 
{
    Newtype(type:litll.idl.std.data.idl.TypeReference);
    Tuple(arguments:Array<litll.idl.std.data.idl.TupleElement>);
    Enum(constructors:Array<litll.idl.std.data.idl.EnumConstructor>);
    Struct(fields:Array<litll.idl.std.data.idl.StructElement>);
}
