package lisla.idl.generator.source.validate;
import hxext.ds.Result;
import lisla.idl.generator.error.IdlValidationErrorKind;
import lisla.idl.generator.error.LoadIdlError;

typedef TypeDefinitionValidationResult = Result<ValidType, Array<LoadIdlError>>;
