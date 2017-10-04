package arraytree.idl.std.entity.idl;
import arraytree.data.meta.core.StringWithMetadata;
import arraytree.idl.std.entity.idl.Argument;

enum EnumConstructorConditionKind 
{
    Label(string:StringWithMetadata);
    Data(name:ArgumentName, );
    Tuple(argument:Argument);
}
