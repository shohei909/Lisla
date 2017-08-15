package lisla.idl.generator.output.error;
import lisla.core.error.FileErrorSummary;
import lisla.error.core.InlineErrorSummary;
import lisla.error.core.LislaError;
import lisla.idl.generator.output.error.GetConfigErrorKind;
import lisla.idl.generator.output.haxe.PrintHaxeErrorKind;
import lisla.idl.generator.output.haxe.PrintHaxeErrorKindTools;

class CompileIdlToHaxeError implements LislaError
{
    public var kind:CompileIdlToHaxeErrorKind;
    public function new(kind:CompileIdlToHaxeErrorKind)
    {
        this.kind = kind;
    }
    
    public function getSummary():InlineErrorSummary
    {
        return switch (kind)
        {
            case CompileIdlToHaxeErrorKind.GetConfig(error):
                error.getSummary();
                
            case CompileIdlToHaxeErrorKind.LoadIdl(error):
                error.getSummary();
                
            case CompileIdlToHaxeErrorKind.Print(error):
                error.getSummary();
        }
    }
}
