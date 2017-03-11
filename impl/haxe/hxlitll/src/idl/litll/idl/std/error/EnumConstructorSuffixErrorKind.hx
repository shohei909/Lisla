package lisla.idl.std.error;
import lisla.idl.std.entity.idl.TypePath;

enum EnumConstructorSuffixErrorKind 
{
    InvalidInlineEnumConstructorParameterLength(actual:Int);
    InvalidInlineEnumConstructorLabel;
    LoopedInline(path:TypePath);
    InlineSuffixForPrimitiveEnumConstructor;
    TupleSuffixForPrimitiveEnumConstructor;
}
