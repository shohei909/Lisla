package lisla.idl.lislatext2entity.error;
import lisla.error.core.BlockToFileErrorWrapper;
import lisla.idl.library.error.FileNotFoundError;

enum LislaFileToEntityErrorKind 
{
    FileNotFound(error:FileNotFoundError);
    LislaTextToEntity(error:BlockToFileErrorWrapper<LislaTextToEntityError>);
}
