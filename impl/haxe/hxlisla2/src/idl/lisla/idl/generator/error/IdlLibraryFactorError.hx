package arraytree.idl.generator.error;
import arraytree.error.core.FileError;
import arraytree.error.core.FileErrorHolder;

class IdlLibraryFactorError 
    implements FileErrorHolder
{
    private var kind:IdlLibraryFactorErrorKind;
    
    public function new(kind:IdlLibraryFactorErrorKind) 
    {
        this.kind = kind;
    }
    
    public function getFileError():FileError
    {
        return switch (kind)
        {
            case IdlLibraryFactorErrorKind.LibraryResolution(error):
                error;
                
            case IdlLibraryFactorErrorKind.NotFound(error):
                error;
        }
    }
}
