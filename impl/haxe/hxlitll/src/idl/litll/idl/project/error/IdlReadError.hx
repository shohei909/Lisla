package litll.idl.project.error;
import litll.core.ds.Maybe;
import litll.core.ds.SourceRange;
import litll.core.tag.StringTag;
import litll.core.tag.Tag;
import litll.idl.std.data.idl.TypePath;
using litll.core.ds.MaybeTools;

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
		return filePath + ": " + switch (errorKind)
		{
			case IdlReadErrorKind.Parse(error):
				error.toString();
				
			case IdlReadErrorKind.Delitll(error):
				error.toString();
				
			case IdlReadErrorKind.ModuleDupplicated(module, existingPath):
				"Module " + module.toString() + " is dupplicated with " + existingPath.toString();
				
			case IdlReadErrorKind.TypeNameDupplicated(typePath):
				getRangeStringFromTag(typePath.tag.upCast()) + "Type " + typePath.toString() + " is dupplicated";
				
			case IdlReadErrorKind.ArgumentNameDupplicated(name):
				getRangeStringFromTag(name.tag.upCast()) + "Argument name " + name + " is dupplicated";
				
			case IdlReadErrorKind.TypeDependenceNameDupplicated(name):
				getRangeStringFromTag(name.tag.upCast()) + "Type dependent name " + name + " is dupplicated";
				
			case IdlReadErrorKind.TypeParameterNameDupplicated(name):
				getRangeStringFromTag(name.tag.upCast()) + "Type parameter name " + name + " is dupplicated";
				
			case IdlReadErrorKind.InvalidPackage(expected, actual):
				getRangeStringFromTag(actual.tag.upCast()) + "Package name " + expected + " is expected but " + actual;
				
			case IdlReadErrorKind.TypeNotFound(path):
				getRangeStringFromTag(path.tag.upCast()) + "Type " + path.toString() + " is not found";
				
			case IdlReadErrorKind.ModuleNotFound(path):
				getRangeStringFromTag(path.tag.upCast()) + "Module " + path.toString() + " is not found";
				
			case IdlReadErrorKind.InvalidTypeParameterLength(path, expected, actual):
				getRangeStringFromTag(path.tag.upCast()) + "Type " + path.toString() + " parameter length is " + expected + " expected but actual " + actual;
				
		}
	}
    
    private function getRangeStringFromTag(tag:Maybe<Tag>):String
    {
        return getRangeString(tag.flatMap(function (t) return t.position));
    }
    
    private function getRangeString(range:Maybe<SourceRange>):String
    {
        return range.map(function (r) return r.toString() + ": ").getOrElse("");
    }
}
