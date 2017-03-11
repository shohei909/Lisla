package litll.idl.std.error;
import litll.core.error.InlineErrorSummary;
import litll.idl.exception.IdlException;
import litll.idl.generator.error.ReadIdlErrorKind;

class GetConditionErrorKindTools 
{
    public static function getSummary(kind:GetConditionErrorKind):InlineErrorSummary<GetConditionErrorKind>
    {
        return switch(kind)
        {
            case GetConditionErrorKind.Follow(error):
                TypeFollowErrorKindTools.getSummary(error).map(GetConditionErrorKind.Follow);
                
            case GetConditionErrorKind.TupleArgumentSuffix(error):
                error.getSummary().replaceKind(kind);
                
            case GetConditionErrorKind.EnumConstructorSuffix(error):
                error.getSummary().replaceKind(kind);
                
            case GetConditionErrorKind.StructFieldSuffix(error):
                error.getSummary().replaceKind(kind);
        }
    }
    
    public static function toIdlException(error:GetConditionErrorKind):IdlException
    {
        return new IdlException(getSummary(error).toString());
    }
}
