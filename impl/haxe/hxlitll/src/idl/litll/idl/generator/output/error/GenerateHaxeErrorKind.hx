package litll.idl.generator.output.error;
import litll.idl.generator.error.ReadIdlError;
import litll.idl.litlltext2entity.error.LitllFileToEntityError;

enum GenerateHaxeErrorKind 
{
   GetLibrary(error:LitllFileToEntityError);
   GetInputConfig(error:LitllFileToEntityError);
   LoadIdl(error:ReadIdlError);
}
