package litll.idl.std.error;
import litll.idl.std.data.idl.EnumConstructorName;
import litll.idl.std.data.idl.TypePath;

enum GetConditionErrorKind
{
    StructFieldSuffix(error:StructFieldSuffixError);
    TupleArgumentSuffix(error:ArgumentSuffixError);
    EnumConstructorSuffix(error:EnumConstructorSuffixError);
    Follow(error:TypeFollowErrorKind);
}
