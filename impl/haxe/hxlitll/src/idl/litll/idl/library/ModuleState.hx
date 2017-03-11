package litll.idl.library;
import hxext.ds.Result;
import litll.idl.generator.error.LoadIdlError;
import litll.idl.generator.source.file.IdlFilePath;
import litll.idl.generator.source.validate.TypeDefinitionValidationResult;
import litll.idl.std.entity.idl.TypeDefinition;

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
