package lisla.idl.generator.error;
import hxext.ds.Maybe;
import lisla.core.Lisla;
import lisla.core.tag.Tag;
import lisla.idl.lislatext2entity.error.LislaTextToEntityErrorKind;
import lisla.idl.std.entity.idl.ModulePath;
import lisla.idl.std.entity.idl.PackagePath;
import lisla.idl.std.entity.idl.TypeName;
import lisla.idl.std.entity.idl.TypePath;
import lisla.idl.std.entity.idl.LibraryName;
import lisla.idl.std.entity.util.version.Version;

enum LoadIdlErrorKind
{
    // Library
    LibraryNotFoundInLibraryConfig(configTag:Maybe<Tag>, ownerName:String, referencedName:String);
    LibraryNotFound(name:LibraryName);
    LibraryVersionNotFound(name:String, version:Version);
    
    // 
    LislaTextToEntity(error:LislaTextToEntityErrorKind);
    
    // Preprocess
    ModuleDuplicated(module:ModulePath, existingPath:String);
	TypeNotFound(path:TypePath);
	TypeNameDuplicated(path:TypePath);
	InvalidPackage(expected:PackagePath, actual:PackagePath);
	ModuleNotFound(module:ModulePath);
    InvalidTypeDependenceDescription(path:Lisla);
    TypeParameterNameDuplicated(name:TypeName);
    
    // Validate
    Validation(error:IdlValidationErrorKind);
}
