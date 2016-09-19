package sora.idl.project.error;
import sora.idl.std.data.idl.TypePath;

class IdlReadError
{
	public var filePath(default, null):String;
	public var errorKind(default, null):IdlReadErrorKind;
	
	public function new(filePath:String, errorKind:IdlReadErrorKind) 
	{
		this.filePath = filePath;
		this.errorKind = errorKind;
	}
	
	public function toString():String
	{
		return filePath + ":" + switch (errorKind)
		{
			case IdlReadErrorKind.Parse(error):
				error.toString();
				
			case IdlReadErrorKind.Desoralize(error):
				error.toString();
				
			case IdlReadErrorKind.ModuleDupplicated(module, existingPath):
				"Module " + module + " is dupplicated with " + existingPath;
				
			case IdlReadErrorKind.ArgumentNameDupplicated(name):
				"Argument name " + name + " is dupplicated";
				
			case IdlReadErrorKind.TypeDependenceNameDupplicated(name):
				"Type dependent name " + name + " is dupplicated";
				
			case IdlReadErrorKind.TypeParameterNameDupplicated(name):
				"Type parameter name " + name + " is dupplicated";
				
			case IdlReadErrorKind.InvalidPackage(expected, actual):
				"Package name " + expected + " is expected but " + actual;
				
			case IdlReadErrorKind.TypeNotFound(path):
				"Type " + path + " is not found";
		}
	}
}