package litll.project.error;
import litll.core.error.FileErrorSummary;
import litll.idl.generator.output.error.CompileIdlToHaxeErrorKind;
import litll.idl.generator.output.error.CompileIdlToHaxeErrorKindTools;

class HxlitllErrorKindTools 
{
    public static function getSummary(kind:HxlitllErrorKind):FileErrorSummary<HxlitllErrorKind>
    {
        return switch (kind)
        {
            case HxlitllErrorKind.LoadProject(error):
                error.getSummary().replaceKind(kind);
                
            case HxlitllErrorKind.CompileIdlToHaxe(error):
                CompileIdlToHaxeErrorKindTools.getSummary(error).replaceKind(kind);
        }
    }
}
