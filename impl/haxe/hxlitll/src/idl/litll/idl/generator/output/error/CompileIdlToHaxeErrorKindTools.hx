package litll.idl.generator.output.error;
import litll.core.error.FileErrorSummary;
import litll.idl.generator.output.error.GetConfigErrorKind;
import litll.idl.generator.output.haxe.PrintHaxeErrorKind;
import litll.idl.generator.output.haxe.PrintHaxeErrorKindTools;

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
