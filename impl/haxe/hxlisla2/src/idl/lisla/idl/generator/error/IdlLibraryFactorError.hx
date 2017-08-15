package lisla.idl.generator.error;
import lisla.error.core.FileError;
import lisla.error.core.FileErrorHolder;

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
