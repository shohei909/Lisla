package lisla.idl.generator.error;
import lisla.data.tree.al.AlTree;
import lisla.idl.lislatext2entity.error.LislaTextToEntityError;
import lisla.idl.std.entity.idl.ModulePath;
import lisla.idl.std.entity.idl.PackagePath;
import lisla.idl.std.entity.idl.TypeName;
import lisla.idl.std.entity.idl.TypePath;

enum IdlModuleFactorErrorKind 
{
    // Validate
    Validation(error:IdlValidationError);
    TypeReferenceToEntity(error:LislaTextToEntityError);
	TypeNameDuplicated(path:TypePath);
	InvalidPackage(expected:PackagePath, actual:PackagePath);
    TypeParameterNameDuplicated(name:TypeName);
    ModuleNotFound(modulePath:ModulePath);
    TypeNotFound(typeName:TypeName);
    InvalidTypeDependenceDescription(alTree:AlTree<String>);
}
