package arraytree.idl.generator.output.error;
import arraytree.core.error.FileErrorSummary;
import arraytree.error.core.InlineErrorSummary;
import arraytree.error.core.ArrayTreeError;
import arraytree.idl.generator.output.error.GetConfigErrorKind;
import arraytree.idl.generator.output.haxe.PrintHaxeErrorKind;
import arraytree.idl.generator.output.haxe.PrintHaxeErrorKindTools;

class CompileIdlToHaxeError implements ArrayTreeError
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
