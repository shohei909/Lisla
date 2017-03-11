package lisla.idl.generator.output.error;
import lisla.idl.generator.error.LoadIdlError;
import lisla.idl.lislatext2entity.error.LislaFileToEntityError;

enum GetConfigErrorKind
{
   GetLibrary(error:LislaFileToEntityError);
   GetInputConfig(error:LislaFileToEntityError);
}
