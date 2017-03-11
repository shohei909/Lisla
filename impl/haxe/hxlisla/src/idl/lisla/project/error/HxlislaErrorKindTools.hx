package lisla.project.error;
import lisla.core.error.FileErrorSummary;
import lisla.idl.generator.output.error.CompileIdlToHaxeErrorKind;
import lisla.idl.generator.output.error.CompileIdlToHaxeErrorKindTools;

class HxlislaErrorKindTools 
{
    public static function getSummary(kind:HxlislaErrorKind):FileErrorSummary<HxlislaErrorKind>
    {
        return switch (kind)
        {
            case HxlislaErrorKind.LoadProject(error):
                error.getSummary().replaceKind(kind);
                
            case HxlislaErrorKind.CompileIdlToHaxe(error):
                CompileIdlToHaxeErrorKindTools.getSummary(error).replaceKind(kind);
        }
    }
}
