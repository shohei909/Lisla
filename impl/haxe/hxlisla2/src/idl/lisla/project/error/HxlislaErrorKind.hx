package lisla.project.error;
import lisla.idl.generator.output.error.CompileIdlToHaxeErrorKind;
import lisla.idl.lislatext2entity.error.LislaFileToEntityError;

enum HxlislaErrorKind 
{
    LoadProject(error:LislaFileToEntityError);
    CompileIdlToHaxe(error:CompileIdlToHaxeErrorKind);
}
