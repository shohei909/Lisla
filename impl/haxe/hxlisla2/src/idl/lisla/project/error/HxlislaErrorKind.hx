package arraytree.project.error;
import arraytree.idl.generator.output.error.CompileIdlToHaxeErrorKind;
import arraytree.idl.arraytreetext2entity.error.ArrayTreeFileToEntityError;

enum HxarraytreeErrorKind 
{
    LoadProject(error:ArrayTreeFileToEntityError);
    CompileIdlToHaxe(error:CompileIdlToHaxeErrorKind);
}
