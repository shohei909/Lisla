package lisla.idl.generator.output.error;
import lisla.core.error.FileErrorSummary;
import lisla.idl.generator.output.error.GetConfigErrorKind;
import lisla.idl.generator.output.haxe.PrintHaxeErrorKind;
import lisla.idl.generator.output.haxe.PrintHaxeErrorKindTools;

class CompileIdlToHaxeErrorKindTools
{
    
    public static function getSummary(kind:CompileIdlToHaxeErrorKind):FileErrorSummary<CompileIdlToHaxeErrorKind>
    {
        return switch (kind)
        {
            case CompileIdlToHaxeErrorKind.GetConfig(error):
                GetConfigErrorKindTools.getSummary(error).replaceKind(kind);
                
            case CompileIdlToHaxeErrorKind.LoadIdl(error):
                error.getSummary().replaceKind(kind);
                
            case CompileIdlToHaxeErrorKind.Print(error):
                PrintHaxeErrorKindTools.getSummary(error).replaceKind(kind);
        }
    }
}
