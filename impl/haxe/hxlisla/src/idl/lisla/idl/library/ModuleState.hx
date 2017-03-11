package lisla.idl.library;
import hxext.ds.Result;
import lisla.idl.generator.error.LoadIdlError;
import lisla.idl.generator.source.file.IdlFilePath;
import lisla.idl.generator.source.validate.TypeDefinitionValidationResult;
import lisla.idl.std.entity.idl.TypeDefinition;

enum ModuleState 
{
	None;
	Empty;
	Resolving(
        types:Map<String, TypeDefinition>, 
        file:IdlFilePath
    );
	Resolved(
        types:Result<Map<String, TypeDefinition>, Array<LoadIdlError>>, 
        file:IdlFilePath
    );
    Validating(
        types:Map<String, TypeDefinition>, 
        file:IdlFilePath
    );
    Validated(
        types:Map<String, TypeDefinitionValidationResult>,
        file:IdlFilePath
    );
}