package lisla.idl.lislatext2entity.error;
import hxext.ds.Maybe;
import lisla.core.error.InlineErrorSummary;
import lisla.idl.lislatext2entity.error.LislaFileToEntityErrorKind;

class LislaFileToEntityErrorKindTools 
{
    public static function getSummary(kind:LislaFileToEntityErrorKind):InlineErrorSummary<LislaFileToEntityErrorKind>
    {
        return switch(kind)
        {
			case LislaFileToEntityErrorKind.LislaTextToEntity(error):
				LislaTextToEntityErrorKindTools.getSummary(error).replaceKind(kind);
                
            case LislaFileToEntityErrorKind.FileNotFound:
                new InlineErrorSummary(
                    Maybe.none(), 
                    "File is not found.",
                    kind
                );
		}
    }
}
