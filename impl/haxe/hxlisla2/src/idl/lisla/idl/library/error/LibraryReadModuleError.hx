package arraytree.idl.library.error;
import haxe.ds.Option;
import arraytree.error.core.BlockError;
import arraytree.idl.arraytreetext2entity.error.ArrayTreeTextToEntityError;
import arraytree.project.FilePathFromProjectRoot;
import arraytree.data.meta.position.SourceMap;
import arraytree.error.core.FileError;
import arraytree.project.ProjectRootAndFilePath;

class LibraryReadModuleError 
    implements FileError
{
    public var kind:LibraryReadModuleErrorKind;
    public var filePath(default, null):ProjectRootAndFilePath;
    
    public function new(kind:LibraryReadModuleErrorKind, filePath:ProjectRootAndFilePath)
    {
        this.kind = kind;
        this.filePath = filePath;
    }
    
    public function getOptionFilePath():Option<ProjectRootAndFilePath> 
    {
        return Option.Some(filePath);
    }
    
    public function getBlockError():BlockError 
    {
        return switch (kind)
        {
            case LibraryReadModuleErrorKind.ArrayTreeTextToEntity(error):
                error;
                
            case LibraryReadModuleErrorKind.ModuleResolution(error):
                error;
        }
    }
    
    public function getFileError():FileError
    {
        return this;
    }
    
    public static function ofArrayTreeTextToEntity(error:ArrayTreeTextToEntityError, filePath:ProjectRootAndFilePath) 
    {
        return new LibraryReadModuleError(
            LibraryReadModuleErrorKind.ArrayTreeTextToEntity(error),
            filePath
        );
    }
    
    public static function ofModuleResolution(error:ModuleResolutionError, filePath:ProjectRootAndFilePath) 
    {
        return new LibraryReadModuleError(
            LibraryReadModuleErrorKind.ModuleResolution(error),
            filePath
        );
    }
}
