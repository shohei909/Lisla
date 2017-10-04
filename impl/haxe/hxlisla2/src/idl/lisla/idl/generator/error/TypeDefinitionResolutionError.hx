package arraytree.idl.generator.error;
import arraytree.error.core.BlockError;
import arraytree.error.core.ElementaryError;
import arraytree.error.core.FileError;
import arraytree.error.core.InlineError;

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
