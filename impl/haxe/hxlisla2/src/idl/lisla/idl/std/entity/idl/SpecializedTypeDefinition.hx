package arraytree.idl.std.entity.idl;
import arraytree.idl.std.entity.idl.EnumConstructor;
import arraytree.idl.std.entity.idl.StructElement;
import arraytree.idl.std.entity.idl.TupleElement;
import arraytree.idl.std.entity.idl.TypeReference;

enum SpecializedTypeDefinition 
{
    Newtype(type:arraytree.idl.std.entity.idl.TypeReference);
    Tuple(arguments:Array<arraytree.idl.std.entity.idl.TupleElement>);
    Enum(constructors:Array<arraytree.idl.std.entity.idl.EnumConstructor>);
    Struct(fields:Array<arraytree.idl.std.entity.idl.StructElement>);
}
