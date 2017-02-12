package litll.idl.std.error;
import litll.idl.std.data.idl.ArgumentKind;
import litll.idl.std.data.idl.TypeReference;

enum ArgumentSuffixErrorKind 
{
    InlineString;
    FirstElementRequired;
    UnsupportedDefault(kind:ArgumentKind);
}