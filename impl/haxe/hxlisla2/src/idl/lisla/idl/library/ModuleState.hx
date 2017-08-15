package lisla.idl.library;
import hxext.ds.Result;
import lisla.idl.generator.error.LoadIdlError;
import lisla.idl.generator.source.validate.TypeDefinitionValidationResult;
import lisla.idl.std.entity.idl.TypeDefinition;
import lisla.project.ProjectRootAndFilePath;
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
