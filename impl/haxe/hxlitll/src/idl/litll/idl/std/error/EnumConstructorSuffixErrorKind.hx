package litll.idl.std.error;
import litll.idl.std.data.idl.TypePath;

enum EnumConstructorSuffixErrorKind 
{
    InvalidInlineEnumConstructorParameterLength(actual:Int);
    InvalidInlineEnumConstructorLabel;
    LoopedInline(path:TypePath);
    InlineSuffixForPrimitiveEnumConstructor;
    TupleSuffixForPrimitiveEnumConstructor;
}
