package sora.idl.project.error;
import sora.core.parse.ParseError;
import sora.idl.desoralize.DesoralizeError;
import sora.idl.std.data.idl.ArgumentName;
import sora.idl.std.data.idl.ModulePath;
import sora.idl.std.data.idl.PackagePath;
import sora.idl.std.data.idl.TypeDependenceName;
import sora.idl.std.data.idl.TypeName;
import sora.idl.std.data.idl.TypePath;

enum IdlReadErrorKind
{
	Parse(error:ParseError);
	Desoralize(error:DesoralizeError);
	ModuleDupplicated(module:ModulePath, existingPath:String);
	InvalidPackage(expected:PackagePath, actual:PackagePath);
	TypeNotFound(path:TypePath);
	TypeParameterNameDupplicated(name:TypeName);
	TypeDependenceNameDupplicated(name:TypeDependenceName);
	ArgumentNameDupplicated(name:String);
}