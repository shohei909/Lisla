package lisla.idl.lislatext2entity.error;
import lisla.core.error.InlineErrorSummary;

class LislaTextToEntityErrorKindTools 
{
    public static function getSummary(kind:LislaTextToEntityErrorKind):InlineErrorSummary<LislaTextToEntityErrorKind>
    {
        return switch(kind)
        {
			case LislaTextToEntityErrorKind.Parse(error):
                error.getSummary().replaceKind(kind);
				
			case LislaTextToEntityErrorKind.LislaToEntity(error):
				error.getSummary().replaceKind(kind);
		}
    }
}
