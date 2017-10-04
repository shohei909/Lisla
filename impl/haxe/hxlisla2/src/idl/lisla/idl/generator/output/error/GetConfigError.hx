package arraytree.idl.generator.output.error;
import arraytree.core.error.FileErrorSummary;
import arraytree.error.core.InlineErrorSummary;
import arraytree.error.core.ArrayTreeError;
import arraytree.idl.arraytreetext2entity.error.ArrayTreeFileToEntityErrorKind;
import arraytree.idl.arraytreetext2entity.error.ArrayTreeFileToEntityErrorKindTools;

class GetConfigError implements ArrayTreeError
{
    public function new(kind:GetConfigErrorKind)
    {
        
    }
    
    public function getSummary():InlineErrorSummary
    {
        return switch (kind)
        {
            case GetConfigErrorKind.GetGenerationConfig(error):
                error.getSummary();
                
            case GetConfigErrorKind.GetLibrary(error):
                error.getSummary();
        }
    }
}