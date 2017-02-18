package litll.idl.litlltext2entity.error;
import litll.core.error.ErrorSummary;

class LitllTextToEntityErrorKindTools 
{
    public static function getSummary(kind:LitllTextToEntityErrorKind):ErrorSummary
    {
        return switch(kind)
        {
			case LitllTextToEntityErrorKind.Parse(error):
                error.getSummary();
				
			case LitllTextToEntityErrorKind.LitllToEntity(error):
				error.getSummary();
		}
    }
}
