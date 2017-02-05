package litll.idl.std.tools.idl.error;
import litll.idl.exception.IdlException;
import litll.idl.generator.error.IdlReadErrorKind;

class TypeFollowErrorKindTools
{
    public static function toString(error:TypeFollowErrorKind):String
    {
        return switch(error)
        {
            case TypeFollowErrorKind.InvalidTypeParameterLength(typePath, expected, actual):
                "invalid type parameters length. " + typePath.toString() + " expect " + expected + ", but actual " + actual;
                
            case TypeFollowErrorKind.LoopedNewtype(typePath):
                "Type " + typePath.toString() + " is looping.";
        }
    }
    
    public static function toIdlReadErrorKind(error:TypeFollowErrorKind):IdlReadErrorKind
    {
        return switch(error)
        {
            case TypeFollowErrorKind.InvalidTypeParameterLength(typePath, expected, actual):
                IdlReadErrorKind.InvalidTypeParameterLength(typePath, expected, actual);
                
            case TypeFollowErrorKind.LoopedNewtype(typePath):
                IdlReadErrorKind.LoopedNewtype(typePath);
        }
    }
    
    public static function toIdlException(error:TypeFollowErrorKind):IdlException
    {
        return new IdlException(toString(error));
    }
}