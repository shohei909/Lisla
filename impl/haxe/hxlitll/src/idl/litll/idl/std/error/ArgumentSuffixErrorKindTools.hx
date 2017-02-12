package litll.idl.std.error;
import litll.idl.exception.IdlException;

class ArgumentSuffixErrorKindTools 
{
    public static function toString(kind:ArgumentSuffixErrorKind):String
    {
        return switch(kind)
        {
            case ArgumentSuffixErrorKind.InlineString:
                "string can't be inlined";
                
            case ArgumentSuffixErrorKind.UnsupportedDefault(kind):
                "Default is unsupported for value kind " + kind + ".";
                
            case ArgumentSuffixErrorKind.FirstElementRequired:
                "First element is required for the argument's type.";
        }
    }   
    
    public static function toIdlException(kind:ArgumentSuffixErrorKind):IdlException
    {
        return new IdlException(toString(kind));
    }
}
