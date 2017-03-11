package litll.idl.library;
import hxext.ds.Result;
import litll.idl.generator.error.ReadIdlError;
import litll.idl.generator.source.file.IdlFilePath;
import litll.idl.generator.source.validate.TypeDefinitionValidationResult;
import litll.idl.std.data.idl.TypeDefinition;

enum ModuleState 
{
	Unloaded;
	Empty;
	Loading(
        types:Map<String, TypeDefinition>, 
        file:IdlFilePath
    );
	Loaded(
        types:Result<Map<String, TypeDefinition>, Array<ReadIdlError>>, 
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
