package lisla.idl.generator.output.error;
import lisla.core.error.FileErrorSummary;
import lisla.error.core.InlineErrorSummary;
import lisla.error.core.LislaError;
import lisla.idl.lislatext2entity.error.LislaFileToEntityErrorKind;
import lisla.idl.lislatext2entity.error.LislaFileToEntityErrorKindTools;

class GetConfigError implements LislaError
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