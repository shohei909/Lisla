package litll.idl.generator.error;
import hxext.ds.Maybe;
import litll.core.Litll;
import litll.core.tag.Tag;
import litll.idl.litlltext2entity.error.LitllTextToEntityErrorKind;
import litll.idl.std.entity.idl.ModulePath;
import litll.idl.std.entity.idl.PackagePath;
import litll.idl.std.entity.idl.TypeName;
import litll.idl.std.entity.idl.TypePath;
import litll.idl.std.entity.idl.LibraryName;
import litll.idl.std.entity.util.version.Version;

enum ReadIdlErrorKind
{
    // Library
    LibraryNotFoundInLibraryConfig(configTag:Maybe<Tag>, ownerName:String, referencedName:String);
    LibraryNotFound(name:LibraryName);
    LibraryVersionNotFound(name:String, version:Version);
    
    // 
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
