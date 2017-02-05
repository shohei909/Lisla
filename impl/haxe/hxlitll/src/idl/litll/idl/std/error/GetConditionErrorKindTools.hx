package litll.idl.std.error;
import litll.core.error.LitllErrorSummary;
import litll.idl.exception.IdlException;
import litll.idl.generator.error.IdlReadErrorKind;

class GetConditionErrorKindTools 
{
    public static function getSummary(error:GetConditionErrorKind):LitllErrorSummary
    {
        return switch(error)
        {
            case GetConditionErrorKind.Follow(error):
                TypeFollowErrorKindTools.getSummary(error);
                
            case GetConditionErrorKind.TupleArgumentSuffix(error):
                error.getSummary();
                
            case GetConditionErrorKind.EnumConstructorSuffix(error):
                error.getSummary();
                
            case GetConditionErrorKind.StructFieldSuffix(error):
                error.getSummary();
        }
    }
    
    public static function toIdlException(error:GetConditionErrorKind):IdlException
    {
        return new IdlException(getSummary(error).toString());
    }
}
