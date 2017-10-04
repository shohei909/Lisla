package arraytree.idl.arraytreetext2entity.error;
import haxe.ds.Option;
import arraytree.error.core.BlockToFileErrorWrapper;
import arraytree.error.core.FileError;
import arraytree.error.core.FileErrorHolder;
import arraytree.idl.library.error.FileNotFoundError;
import arraytree.project.ProjectRootAndFilePath;
import arraytree.project.ProjectRootDirectory;

class ArrayTreeFileToEntityError implements FileErrorHolder
{
    public var kind(default, null):ArrayTreeFileToEntityErrorKind;
    
    public function new(kind:ArrayTreeFileToEntityErrorKind)
    {
        this.kind = kind;
    }
    
    public function getFileError():FileError
    {
        return switch(kind)
        {
			case ArrayTreeFileToEntityErrorKind.ArrayTreeTextToEntity(error):
				error;
                
            case ArrayTreeFileToEntityErrorKind.FileNotFound(error):
                error;
		}
    }
    
    public static function ofArrayTreeTextToEntity(
        error:ArrayTreeTextToEntityError,
        filePath:ProjectRootAndFilePath
    ):ArrayTreeFileToEntityError
    {
        return new ArrayTreeFileToEntityError(
            ArrayTreeFileToEntityErrorKind.ArrayTreeTextToEntity(
                new BlockToFileErrorWrapper(error, Option.Some(filePath))
            )
        );
    }
    
    public static function ofFileNotFound(
        filePath:ProjectRootAndFilePath
    ):ArrayTreeFileToEntityError
    {
        return new ArrayTreeFileToEntityError(
            ArrayTreeFileToEntityErrorKind.FileNotFound(
                new FileNotFoundError(filePath)
            )
        );
    }
}
