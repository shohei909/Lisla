package lisla.idl.library.error;
import haxe.ds.Option;
import lisla.error.core.BlockError;
import lisla.idl.lislatext2entity.error.LislaTextToEntityError;
import lisla.project.FilePathFromProjectRoot;
import lisla.data.meta.position.SourceMap;
import lisla.error.core.FileError;
import lisla.project.ProjectRootAndFilePath;

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
            case LibraryReadModuleErrorKind.LislaTextToEntity(error):
                error;
                
            case LibraryReadModuleErrorKind.ModuleResolution(error):
                error;
        }
    }
    
    public function getFileError():FileError
    {
        return this;
    }
    
    public static function ofLislaTextToEntity(error:LislaTextToEntityError, filePath:ProjectRootAndFilePath) 
    {
        return new LibraryReadModuleError(
            LibraryReadModuleErrorKind.LislaTextToEntity(error),
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
