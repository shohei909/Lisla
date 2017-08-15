package lisla.idl.lislatext2entity.error;
import haxe.ds.Option;
import lisla.error.core.BlockToFileErrorWrapper;
import lisla.error.core.FileError;
import lisla.error.core.FileErrorHolder;
import lisla.idl.library.error.FileNotFoundError;
import lisla.project.ProjectRootAndFilePath;
import lisla.project.ProjectRootDirectory;

class LislaFileToEntityError implements FileErrorHolder
{
    public var kind(default, null):LislaFileToEntityErrorKind;
    
    public function new(kind:LislaFileToEntityErrorKind)
    {
        this.kind = kind;
    }
    
    public function getFileError():FileError
    {
        return switch(kind)
        {
			case LislaFileToEntityErrorKind.LislaTextToEntity(error):
				error;
                
            case LislaFileToEntityErrorKind.FileNotFound(error):
                error;
		}
    }
    
    public static function ofLislaTextToEntity(
        error:LislaTextToEntityError,
        filePath:ProjectRootAndFilePath
    ):LislaFileToEntityError
    {
        return new LislaFileToEntityError(
            LislaFileToEntityErrorKind.LislaTextToEntity(
                new BlockToFileErrorWrapper(error, Option.Some(filePath))
            )
        );
    }
    
    public static function ofFileNotFound(
        filePath:ProjectRootAndFilePath
    ):LislaFileToEntityError
    {
        return new LislaFileToEntityError(
            LislaFileToEntityErrorKind.FileNotFound(
                new FileNotFoundError(filePath)
            )
        );
    }
}
