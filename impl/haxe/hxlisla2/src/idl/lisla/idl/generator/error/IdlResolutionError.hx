package lisla.idl.generator.error;
import lisla.error.core.FileError;
import lisla.error.core.FileErrorHolder;

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
