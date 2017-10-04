package arraytree.idl.std.error;
import arraytree.idl.std.entity.idl.TypePath;

enum EnumConstructorSuffixErrorKind 
{
    InvalidInlineEnumConstructorParameterLength(actual:Int);
    InvalidInlineEnumConstructorLabel;
    LoopedInline(path:TypePath);
    InlineSuffixForPrimitiveEnumConstructor;
    TupleSuffixForPrimitiveEnumConstructor;
}
