package arraytree.idl.generator.error;
import arraytree.error.core.FileError;
import arraytree.error.core.FileErrorHolder;

class IdlResolutionError implements FileErrorHolder
{
    public var kind:IdlResolutionErrorKind;
    
    public function new(kind:IdlResolutionErrorKind) 
    {
        this.kind = kind;
    }
    
    public function getFileError():FileError
    {
        return switch (kind)
        {
            case IdlResolutionErrorKind.LibraryResolution(error):
                error;
                
            case IdlResolutionErrorKind.ModuleNotFound(error):
                error;
                
            case IdlResolutionErrorKind.TypeDefinitionResolution(error):
                error;
        }
    }
    
}
