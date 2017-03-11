package litll.idl.generator.output.error;
import litll.core.error.FileErrorSummary;
import litll.idl.litlltext2entity.error.LitllFileToEntityErrorKind;
import litll.idl.litlltext2entity.error.LitllFileToEntityErrorKindTools;

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