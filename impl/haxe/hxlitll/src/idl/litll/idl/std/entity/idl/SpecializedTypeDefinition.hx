package litll.idl.std.entity.idl;
import litll.idl.std.entity.idl.EnumConstructor;
import litll.idl.std.entity.idl.StructElement;
import litll.idl.std.entity.idl.TupleElement;
import litll.idl.std.entity.idl.TypeReference;

enum SpecializedTypeDefinition 
{
    Newtype(type:litll.idl.std.entity.idl.TypeReference);
    Tuple(arguments:Array<litll.idl.std.entity.idl.TupleElement>);
    Enum(constructors:Array<litll.idl.std.entity.idl.EnumConstructor>);
    Struct(fields:Array<litll.idl.std.entity.idl.StructElement>);
}
