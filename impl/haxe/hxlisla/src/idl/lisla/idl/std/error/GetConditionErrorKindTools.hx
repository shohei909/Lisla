package lisla.idl.std.error;
import lisla.core.error.InlineErrorSummary;
import lisla.idl.exception.IdlException;
import lisla.idl.generator.error.LoadIdlErrorKind;

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