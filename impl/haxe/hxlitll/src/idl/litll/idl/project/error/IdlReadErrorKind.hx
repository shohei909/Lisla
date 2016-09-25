package litll.idl.project.error;
import litll.core.parse.ParseError;
import litll.idl.delitllfy.LitllError;
import litll.idl.std.data.idl.ArgumentName;
import litll.idl.std.data.idl.ModulePath;
import litll.idl.std.data.idl.PackagePath;
import litll.idl.std.data.idl.TypeDependenceName;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypePath;

enum IdlReadErrorKind
{
	Parse(error:ParseError);
	Litll(error:LitllError);
	ModuleDupplicated(module:ModulePath, existingPath:String);
	InvalidPackage(expected:PackagePath, actual:PackagePath);
	TypeNotFound(path:TypePath);
	TypeParameterNameDupplicated(name:TypeName);
	TypeDependenceNameDupplicated(name:TypeDependenceName);
	ArgumentNameDupplicated(name:String);
}