package litll.idl.generator.error;
import hxext.ds.Maybe;
import litll.core.Litll;
import litll.core.tag.Tag;
import litll.idl.litlltext2entity.error.LitllTextToEntityErrorKind;
import litll.idl.std.data.idl.ModulePath;
import litll.idl.std.data.idl.PackagePath;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.LibraryName;
import litll.idl.std.data.util.version.Version;

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
