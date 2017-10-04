package arraytree.idl.std.entity.idl;
import arraytree.idl.std.entity.idl.Argument;
import arraytree.idl.std.entity.idl.EnumConstructor;
import arraytree.idl.std.entity.idl.TupleElement;
import arraytree.idl.std.entity.idl.TypeReference;

enum FollowedTypeDefinition
{
    Arr(elementType:TypeReference);
    Str;
    Enum(constuctors:Array<EnumConstructor>);
    Tuple(elements:Array<TupleElement>);
    Struct(elements:Array<StructElement>);
}
