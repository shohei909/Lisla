package litll.idl.litlltext2entity.error;
import litll.core.error.InlineErrorSummary;

class LitllTextToEntityErrorKindTools 
{
    public static function getSummary(kind:LitllTextToEntityErrorKind):InlineErrorSummary<LitllTextToEntityErrorKind>
    {
        return switch(kind)
        {
			case LitllTextToEntityErrorKind.Parse(error):
                error.getSummary().replaceKind(kind);
				
			case LitllTextToEntityErrorKind.LitllToEntity(error):
				error.getSummary().replaceKind(kind);
		}
    }
}
