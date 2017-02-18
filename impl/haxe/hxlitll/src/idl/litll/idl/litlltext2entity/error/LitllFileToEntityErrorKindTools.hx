package litll.idl.litlltext2entity.error;
import hxext.ds.Maybe;
import litll.core.error.ErrorSummary;
import litll.core.error.LitllErrorSummary;

class LitllFileToEntityErrorKindTools 
{
    public static function getSummary(kind:LitllFileToEntityErrorKind):ErrorSummary
    {
        return switch(kind)
        {
			case LitllFileToEntityErrorKind.LitllTextToEntity(error):
				LitllTextToEntityErrorKindTools.getSummary(error);
                
            case LitllFileToEntityErrorKind.FileNotFound:
                new LitllErrorSummary(Maybe.none(), "File is not found.");
		}
    }
}
