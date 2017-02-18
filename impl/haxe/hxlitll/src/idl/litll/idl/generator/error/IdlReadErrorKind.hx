package litll.idl.generator.error;
import litll.core.Litll;
import litll.core.parse.ParseError;
import litll.core.parse.ParseErrorEntry;
import litll.idl.litlltext2entity.error.LitllFileToEntityErrorKind;
import litll.idl.litll2entity.error.LitllToEntityError;
import litll.idl.litlltext2entity.error.LitllTextToEntityErrorKind;
import litll.idl.std.data.idl.ArgumentName;
import litll.idl.std.data.idl.EnumConstructorName;
import litll.idl.std.data.idl.ModulePath;
import litll.idl.std.data.idl.PackagePath;
import litll.idl.std.data.idl.StructElementName;
import litll.idl.std.data.idl.TypeDependenceName;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.TypeReference;

enum IdlReadErrorKind
{
    LitllTextToEntity(error:LitllTextToEntityErrorKind);
    
    // Preprocess
    ModuleDuplicated(module:ModulePath, existingPath:String);
	TypeNotFound(path:TypePath);
	TypeNameDuplicated(path:TypePath);
	InvalidPackage(expected:PackagePath, actual:PackagePath);
	ModuleNotFound(module:ModulePath);
    InvalidTypeDependenceDescription(path:Litll);
    TypeParameterNameDuplicated(name:TypeName);
    
    // Validate
    Validation(error:IdlValidationErrorKind);
}
