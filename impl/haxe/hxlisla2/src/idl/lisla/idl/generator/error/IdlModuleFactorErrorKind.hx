package arraytree.idl.generator.error;
import arraytree.data.tree.al.AlTree;
import arraytree.idl.arraytreetext2entity.error.ArrayTreeTextToEntityError;
import arraytree.idl.std.entity.idl.ModulePath;
import arraytree.idl.std.entity.idl.PackagePath;
import arraytree.idl.std.entity.idl.TypeName;
import arraytree.idl.std.entity.idl.TypePath;

enum IdlModuleFactorErrorKind 
{
    // Validate
    Validation(error:IdlValidationError);
    TypeReferenceToEntity(error:ArrayTreeTextToEntityError);
	TypeNameDuplicated(path:TypePath);
	InvalidPackage(expected:PackagePath, actual:PackagePath);
    TypeParameterNameDuplicated(name:TypeName);
    ModuleNotFound(modulePath:ModulePath);
    TypeNotFound(typeName:TypeName);
    InvalidTypeDependenceDescription(alTree:AlTree<String>);
}
