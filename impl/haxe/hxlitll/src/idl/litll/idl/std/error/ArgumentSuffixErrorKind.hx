package litll.idl.std.error;
import litll.idl.std.entity.idl.ArgumentKind;
import litll.idl.std.entity.idl.TypeReference;

enum ArgumentSuffixErrorKind 
{
    InlineString;
    FirstElementRequired;
    UnsupportedDefault(kind:ArgumentKind);
}