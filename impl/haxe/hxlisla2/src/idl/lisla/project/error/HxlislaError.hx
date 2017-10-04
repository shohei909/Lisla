package arraytree.project.error;
import arraytree.error.core.InlineErrorSummary;
import arraytree.error.core.ArrayTreeError;
import arraytree.idl.generator.output.error.CompileIdlToHaxeErrorKind;
import arraytree.idl.generator.output.error.CompileIdlToHaxeErrorKindTools;

class HxarraytreeError implements ArrayTreeError
{
    public var kind:HxarraytreeErrorKind;
    public function new(kind:HxarraytreeErrorKind)
    {
        this.kind = kind;
    }
    
    public function getSummary():InlineErrorSummary
    {
        return switch (kind)
        {
            case HxarraytreeErrorKind.LoadProject(error):
                error.getSummary();
                
            case HxarraytreeErrorKind.CompileIdlToHaxe(error):
                error.getSummary();
        }
    }
}
