package arraytree.idl.library;
import hxext.ds.Result;
import arraytree.idl.generator.error.LoadIdlError;
import arraytree.idl.generator.source.validate.TypeDefinitionValidationResult;
import arraytree.idl.std.entity.idl.TypeDefinition;
import arraytree.project.ProjectRootAndFilePath;
enum ModuleState 
{
	None;
	Empty;
	Resolving(
        types:Map<String, TypeDefinition>, 
        file:ProjectRootAndFilePath
    );
	Resolved(
        types:Result<Map<String, TypeDefinition>, Array<LoadIdlError>>, 
        file:ProjectRootAndFilePath
    );
    Validating(
        types:Map<String, TypeDefinition>, 
        file:ProjectRootAndFilePath
    );
    Validated(
        types:Map<String, TypeDefinitionValidationResult>,
        file:ProjectRootAndFilePath
    );
}
