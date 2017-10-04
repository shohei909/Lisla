package arraytree.idl.std.error;
import arraytree.idl.std.entity.idl.EnumConstructorName;
import arraytree.idl.std.entity.idl.TypePath;

enum GetConditionErrorKind
{
    StructFieldSuffix(error:StructFieldSuffixError);
    TupleArgumentSuffix(error:ArgumentSuffixError);
    EnumConstructorSuffix(error:EnumConstructorSuffixError);
    Follow(error:TypeFollowError);
}
