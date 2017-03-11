package lisla.idl.std.error;
import hxext.ds.Maybe;
import lisla.core.error.InlineErrorSummary;
import lisla.idl.exception.IdlException;
import lisla.idl.generator.error.LoadIdlErrorKind;

class TypeFollowErrorKindTools
{
    public static function getSummary(error:TypeFollowErrorKind):InlineErrorSummary<TypeFollowErrorKind>
    {
        return switch(error)
        {
            case TypeFollowErrorKind.InvalidTypeParameterLength(typePath, expected, actual):
                new InlineErrorSummary(
                    typePath.tag.getRange(),
                    "Type parameters length is invalid. " + typePath.toString() + " expects " + expected + ", but actual " + actual,
                    error
                );
                
            case TypeFollowErrorKind.LoopedNewtype(typePath):
                new InlineErrorSummary(
                    typePath.tag.getRange(), 
                    "Type " + typePath.toString() + " is looping.",
                    error
                );
        }
    }
    
    public static function toIdlException(error:TypeFollowErrorKind):IdlException
    {
        return new IdlException(getSummary(error).toString());
    }
}
