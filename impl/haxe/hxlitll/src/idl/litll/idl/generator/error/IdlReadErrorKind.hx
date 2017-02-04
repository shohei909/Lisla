package litll.idl.generator.error;
import litll.core.Litll;
import litll.core.parse.ParseError;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.std.data.idl.ArgumentName;
import litll.idl.std.data.idl.EnumConstructorName;
import litll.idl.std.data.idl.ModulePath;
import litll.idl.std.data.idl.PackagePath;
import litll.idl.std.data.idl.StructFieldName;
import litll.idl.std.data.idl.TypeDependenceName;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypePath;

enum IdlReadErrorKind
{
	// Parse
    Parse(error:ParseError);
    
    // Delitll
	Delitll(error:DelitllfyError);
	
    // Preprocess
    ModuleDupplicated(module:ModulePath, existingPath:String);
	TypeNotFound(path:TypePath);
	TypeNameDupplicated(path:TypePath);
	InvalidPackage(expected:PackagePath, actual:PackagePath);
	ModuleNotFound(module:ModulePath);
    InvalidTypeDependenceDescription(path:Litll);
    
	TypeParameterNameDupplicated(name:TypeName);
	TypeDependenceNameDupplicated(name:TypeDependenceName);
	ArgumentNameDupplicated(name:ArgumentName);
    StructFieldNameDupplicated(name:StructFieldName);
    EnumConstuctorNameDupplicated(name:EnumConstructorName);
    InvalidTypeParameterLength(path:TypePath, expected:Int, actual:Int);
    
    // Validate
    LoopedNewtype(path:TypePath);
}
