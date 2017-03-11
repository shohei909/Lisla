package litll.idl.generator.output.error;
import litll.core.error.FileErrorSummary;
import litll.idl.litlltext2entity.error.LitllFileToEntityErrorKind;
import litll.idl.litlltext2entity.error.LitllFileToEntityErrorKindTools;

class GenerateHaxeErrorKindTools 
{
    public static function getSummary(kind:GenerateHaxeErrorKind):FileErrorSummary<GenerateHaxeErrorKind>
    {
        return switch (kind)
        {
            case GenerateHaxeErrorKind.GetInputConfig(error):
                error.getSummary().replaceKind(kind);
                
            case GenerateHaxeErrorKind.GetLibrary(error):
                error.getSummary().replaceKind(kind);
                
            case GenerateHaxeErrorKind.LoadIdl(error):
                error.getSummary().replaceKind(kind);
        }
    }
}