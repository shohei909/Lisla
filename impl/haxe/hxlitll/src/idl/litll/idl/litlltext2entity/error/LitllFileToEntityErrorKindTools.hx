package litll.idl.litlltext2entity.error;
import hxext.ds.Maybe;
import litll.core.error.InlineErrorSummary;
import litll.idl.litlltext2entity.error.LitllFileToEntityErrorKind;

class LitllFileToEntityErrorKindTools 
{
    public static function getSummary(kind:LitllFileToEntityErrorKind):InlineErrorSummary<LitllFileToEntityErrorKind>
    {
        return switch(kind)
        {
			case LitllFileToEntityErrorKind.LitllTextToEntity(error):
				LitllTextToEntityErrorKindTools.getSummary(error).replaceKind(kind);
                
            case LitllFileToEntityErrorKind.FileNotFound:
                new InlineErrorSummary(
                    Maybe.none(), 
                    "File is not found.",
                    kind
                );
		}
    }
}
