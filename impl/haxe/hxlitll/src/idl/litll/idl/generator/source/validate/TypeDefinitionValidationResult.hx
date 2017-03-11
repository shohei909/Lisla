package litll.idl.generator.source.validate;
import hxext.ds.Result;
import litll.idl.generator.error.IdlValidationErrorKind;
import litll.idl.generator.error.ReadIdlError;

typedef TypeDefinitionValidationResult = Result<ValidType, Array<ReadIdlError>>;
