package lisla.idl.generator.output.error;
import lisla.core.error.FileErrorSummary;
import lisla.idl.lislatext2entity.error.LislaFileToEntityErrorKind;
import lisla.idl.lislatext2entity.error.LislaFileToEntityErrorKindTools;

class GetConfigErrorKindTools
{
    public static function getSummary(kind:GetConfigErrorKind):FileErrorSummary<GetConfigErrorKind>
    {
        return switch (kind)
        {
            case GetConfigErrorKind.GetInputConfig(error):
                error.getSummary().replaceKind(kind);
                
            case GetConfigErrorKind.GetLibrary(error):
                error.getSummary().replaceKind(kind);
        }
    }
}