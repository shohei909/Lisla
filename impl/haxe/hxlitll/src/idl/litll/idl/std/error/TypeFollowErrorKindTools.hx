package litll.idl.std.error;
import litll.core.error.LitllErrorSummary;
import litll.idl.exception.IdlException;
import litll.idl.generator.error.IdlReadErrorKind;
using hxext.ds.MaybeTools;

class TypeFollowErrorKindTools
{
    public static function getSummary(error:TypeFollowErrorKind):LitllErrorSummary
    {
        return switch(error)
        {
            case TypeFollowErrorKind.InvalidTypeParameterLength(typePath, expected, actual):
                LitllErrorSummary.createWithTag(typePath.tag.upCast(), "invalid type parameters length. " + typePath.toString() + " expect " + expected + ", but actual " + actual);
                
            case TypeFollowErrorKind.LoopedNewtype(typePath):
                LitllErrorSummary.createWithTag(typePath.tag.upCast(), "Type " + typePath.toString() + " is looping.");
        }
    }
    
    public static function toIdlException(error:TypeFollowErrorKind):IdlException
    {
        return new IdlException(getSummary(error).toString());
    }
}
