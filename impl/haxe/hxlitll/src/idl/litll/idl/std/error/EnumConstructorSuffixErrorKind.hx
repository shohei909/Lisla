package litll.idl.std.error;

enum EnumConstructorSuffixErrorKind 
{
    InvalidInlineEnumConstructorParameterLength(actual:Int);
    InlineSuffixForPrimitiveEnumConstructor;
    TupleSuffixForPrimitiveEnumConstructor;
}
