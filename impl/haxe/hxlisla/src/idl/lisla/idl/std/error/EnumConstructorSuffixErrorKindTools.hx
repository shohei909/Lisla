package lisla.idl.std.error;

class EnumConstructorSuffixErrorKindTools 
{
    public static function toString(kind:EnumConstructorSuffixErrorKind):String
    {
        return switch(kind)
        {
            case EnumConstructorSuffixErrorKind.InvalidInlineEnumConstructorParameterLength(actual):
                "Inline target type number must be one. but actual " + actual + ".";
                
            case EnumConstructorSuffixErrorKind.InvalidInlineEnumConstructorLabel:
                "Inline target must not be label.";
                
            case EnumConstructorSuffixErrorKind.InlineSuffixForPrimitiveEnumConstructor:
                "Inline is not allowed for primitive enum constructor.";
                
            case EnumConstructorSuffixErrorKind.LoopedInline(typePath):
                "Inline " + typePath.toString() + " is looped.";
                
            case EnumConstructorSuffixErrorKind.TupleSuffixForPrimitiveEnumConstructor:
                "Tuple is not allowed for primitive enum constructor.";
        }
    }
}                            
