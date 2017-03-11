package lisla.idl.std.entity.idl;
import lisla.idl.std.entity.idl.Argument;
import lisla.idl.std.entity.idl.EnumConstructor;
import lisla.idl.std.entity.idl.TupleElement;
import lisla.idl.std.entity.idl.TypeReference;

enum FollowedTypeDefinition
{
    Arr(elementType:TypeReference);
    Str;
    Enum(constuctors:Array<EnumConstructor>);
    Tuple(elements:Array<TupleElement>);
    Struct(elements:Array<StructElement>);
}
