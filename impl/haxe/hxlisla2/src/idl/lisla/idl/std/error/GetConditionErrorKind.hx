package lisla.idl.std.error;
import lisla.idl.std.entity.idl.EnumConstructorName;
import lisla.idl.std.entity.idl.TypePath;

enum GetConditionErrorKind
{
    StructFieldSuffix(error:StructFieldSuffixError);
    TupleArgumentSuffix(error:ArgumentSuffixError);
    EnumConstructorSuffix(error:EnumConstructorSuffixError);
    Follow(error:TypeFollowError);
}
