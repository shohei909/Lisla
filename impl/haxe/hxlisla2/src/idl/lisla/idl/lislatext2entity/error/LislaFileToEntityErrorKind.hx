package arraytree.idl.arraytreetext2entity.error;
import arraytree.error.core.BlockToFileErrorWrapper;
import arraytree.idl.library.error.FileNotFoundError;

enum ArrayTreeFileToEntityErrorKind 
{
    FileNotFound(error:FileNotFoundError);
    ArrayTreeTextToEntity(error:BlockToFileErrorWrapper<ArrayTreeTextToEntityError>);
}
