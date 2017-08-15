package lisla.idl.library.error;
import lisla.error.core.FileError;
import lisla.error.core.FileErrorHolder;
import lisla.idl.std.entity.idl.ModulePath;

class ModuleResolutionError 
    implements FileErrorHolder
{
    public var kind(default, null):ModuleResolutionErrorKind;
    
    public function new(kind:ModuleResolutionErrorKind) 
    {
        this.kind = kind;
    }
    
    public function getFileError():FileError
    {
        return switch (kind)
        {
			case ModuleResolutionErrorKind.LibraryResolution(error):
				error;
                
			case ModuleResolutionErrorKind.NotFound(error):
                error;
        }
    }
}
