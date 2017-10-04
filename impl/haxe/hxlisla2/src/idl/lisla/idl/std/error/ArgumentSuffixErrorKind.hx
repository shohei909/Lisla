package arraytree.idl.std.error;
import arraytree.idl.std.entity.idl.ArgumentKind;
import arraytree.idl.std.entity.idl.TypeReference;

enum ArgumentSuffixErrorKind 
{
    InlineString;
    FirstElementRequired;
    UnsupportedDefault(kind:ArgumentKind);
}