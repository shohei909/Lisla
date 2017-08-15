package lisla.idl.generator.error;
import lisla.error.core.BlockError;
import lisla.error.core.ElementaryError;
import lisla.error.core.FileError;
import lisla.error.core.InlineError;

class TypeDefinitionResolutionError 
    implements FileError
    implements BlockError
    implements InlineError
    implements ElementaryError

{
    private var kind(default, null):TypeDefinitionResolutionErrorKind;
    
    public function new(kind:TypeDefinitionResolutionErrorKind)
    {
        this.kind = kind;
    }
}
