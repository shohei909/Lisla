package lisla.idl.std.entity.idl;
import lisla.idl.std.entity.idl.EnumConstructor;
import lisla.idl.std.entity.idl.StructElement;
import lisla.idl.std.entity.idl.TupleElement;
import lisla.idl.std.entity.idl.TypeReference;

enum SpecializedTypeDefinition 
{
    Newtype(type:lisla.idl.std.entity.idl.TypeReference);
    Tuple(arguments:Array<lisla.idl.std.entity.idl.TupleElement>);
    Enum(constructors:Array<lisla.idl.std.entity.idl.EnumConstructor>);
    Struct(fields:Array<lisla.idl.std.entity.idl.StructElement>);
}
