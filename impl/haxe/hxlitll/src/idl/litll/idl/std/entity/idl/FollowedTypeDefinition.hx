package litll.idl.std.entity.idl;
import litll.idl.std.entity.idl.Argument;
import litll.idl.std.entity.idl.EnumConstructor;
import litll.idl.std.entity.idl.TupleElement;
import litll.idl.std.entity.idl.TypeReference;

enum FollowedTypeDefinition
{
    Arr(elementType:TypeReference);
    Str;
    Enum(constuctors:Array<EnumConstructor>);
    Tuple(elements:Array<TupleElement>);
    Struct(elements:Array<StructElement>);
}
