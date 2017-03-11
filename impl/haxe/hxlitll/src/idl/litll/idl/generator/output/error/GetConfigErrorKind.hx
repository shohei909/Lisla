package litll.idl.generator.output.error;
import litll.idl.generator.error.LoadIdlError;
import litll.idl.litlltext2entity.error.LitllFileToEntityError;

enum GetConfigErrorKind
{
   GetLibrary(error:LitllFileToEntityError);
   GetInputConfig(error:LitllFileToEntityError);
}
