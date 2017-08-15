package lisla.project.error;
import lisla.error.core.InlineErrorSummary;
import lisla.error.core.LislaError;
import lisla.idl.generator.output.error.CompileIdlToHaxeErrorKind;
import lisla.idl.generator.output.error.CompileIdlToHaxeErrorKindTools;

class HxlislaError implements LislaError
{
    public var kind:HxlislaErrorKind;
    public function new(kind:HxlislaErrorKind)
    {
        this.kind = kind;
    }
    
    public function getSummary():InlineErrorSummary
    {
        return switch (kind)
        {
            case HxlislaErrorKind.LoadProject(error):
                error.getSummary();
                
            case HxlislaErrorKind.CompileIdlToHaxe(error):
                error.getSummary();
        }
    }
}
