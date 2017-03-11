package litll.project.error;
import litll.idl.generator.output.error.CompileIdlToHaxeErrorKind;
import litll.idl.litlltext2entity.error.LitllFileToEntityError;

enum HxlitllErrorKind 
{
    LoadProject(error:LitllFileToEntityError);
    CompileIdlToHaxe(error:CompileIdlToHaxeErrorKind);
}
