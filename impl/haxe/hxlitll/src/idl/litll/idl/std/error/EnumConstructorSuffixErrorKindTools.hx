package litll.idl.std.error;

class EnumConstructorSuffixErrorKindTools 
{
    public static function toString(kind:EnumConstructorSuffixErrorKind):String
    {
        return switch(kind)
        {
            case EnumConstructorSuffixErrorKind.InvalidInlineEnumConstructorParameterLength(actual):
                "inline target type number must be one. but actual " + actual;
                
            case EnumConstructorSuffixErrorKind.InlineSuffixForPrimitiveEnumConstructor:
                "inline is not allowed for primitive enum constructor";
                
            case EnumConstructorSuffixErrorKind.TupleSuffixForPrimitiveEnumConstructor:
                "tuple is not allowed for primitive enum constructor";
        }
    }
}                            
