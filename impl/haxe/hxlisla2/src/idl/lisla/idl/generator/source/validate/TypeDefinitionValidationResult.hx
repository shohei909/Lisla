package arraytree.idl.generator.source.validate;
import hxext.ds.Result;
import arraytree.idl.generator.error.IdlValidationErrorKind;
import arraytree.idl.generator.error.LoadIdlError;

typedef TypeDefinitionValidationResult = Result<ValidType, Array<LoadIdlError>>;
