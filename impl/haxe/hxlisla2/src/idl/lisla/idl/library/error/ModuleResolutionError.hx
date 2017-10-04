package arraytree.idl.library.error;
import arraytree.error.core.FileError;
import arraytree.error.core.FileErrorHolder;
import arraytree.idl.std.entity.idl.ModulePath;

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
