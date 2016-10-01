package litll.idl.project.error;
import litll.core.parse.ParseError;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.std.data.idl.ArgumentName;
import litll.idl.std.data.idl.ModulePath;
import litll.idl.std.data.idl.PackagePath;
import litll.idl.std.data.idl.TypeDependenceName;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypePath;

enum IdlReadErrorKind
{
	Parse(error:ParseError);
	Delitll(error:DelitllfyError);
	ModuleDupplicated(module:ModulePath, existingPath:String);
	TypeNotFound(path:TypePath);
	TypeNameDupplicated(path:TypePath);
	InvalidPackage(expected:PackagePath, actual:PackagePath);
	ModuleNotFound(module:ModulePath);
	TypeParameterNameDupplicated(name:TypeName);
	TypeDependenceNameDupplicated(name:TypeDependenceName);
	ArgumentNameDupplicated(name:String);
	InvalidTypeParameterLength(path:TypePath, expected:Int, actual:Int);
}

