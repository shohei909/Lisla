package lisla.idl.std.error;
import lisla.idl.std.entity.idl.ArgumentKind;
import lisla.idl.std.entity.idl.TypeReference;

enum ArgumentSuffixErrorKind 
{
    InlineString;
    FirstElementRequired;
    UnsupportedDefault(kind:ArgumentKind);
}