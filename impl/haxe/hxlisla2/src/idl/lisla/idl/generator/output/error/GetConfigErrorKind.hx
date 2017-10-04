package arraytree.idl.generator.output.error;
import arraytree.idl.generator.error.LoadIdlError;
import arraytree.idl.arraytreetext2entity.error.ArrayTreeFileToEntityError;

enum GetConfigErrorKind
{
   GetLibrary(error:ArrayTreeFileToEntityError);
   GetGenerationConfig(error:ArrayTreeFileToEntityError);
}
