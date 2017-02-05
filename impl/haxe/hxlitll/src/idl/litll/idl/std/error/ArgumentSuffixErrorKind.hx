package litll.idl.std.error;
import litll.idl.std.data.idl.ArgumentKind;

enum ArgumentSuffixErrorKind 
{
    InlineString;
    UnsupportedDefault(kind:ArgumentKind);
}