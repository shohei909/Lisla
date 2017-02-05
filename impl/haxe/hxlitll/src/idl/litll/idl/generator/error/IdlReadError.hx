package litll.idl.generator.error;
import litll.core.LitllTools;
import litll.core.ds.Maybe;
import litll.core.ds.SourceRange;
import litll.core.print.Printer;
import litll.core.tag.Tag;
import litll.idl.generator.source.file.IdlFilePath;
import litll.idl.std.tools.idl.TypeReferenceTools;
using litll.core.ds.MaybeTools;

class IdlReadError
{
	public var filePath(default, null):IdlFilePath;
	public var errorKind(default, null):IdlReadErrorKind;
	
	public function new(filePath:IdlFilePath, errorKind:IdlReadErrorKind) 
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
				getRangeStringFromTag(name.tag.upCast()) + "Argument name " + name.name + " is dupplicated";
				
			case IdlReadErrorKind.EnumConstuctorNameDupplicated(name):
				getRangeStringFromTag(name.tag.upCast()) + "Enum constructor name " + name.name + " is dupplicated";
				
			case IdlReadErrorKind.StructFieldNameDupplicated(name):
				getRangeStringFromTag(name.tag.upCast()) + "Struct field name " + name.name + " is dupplicated";
				
			case IdlReadErrorKind.TypeDependenceNameDupplicated(name):
				getRangeStringFromTag(name.tag.upCast()) + "Type dependent name " + name.data + " is dupplicated";
				
			case IdlReadErrorKind.TypeParameterNameDupplicated(name):
				getRangeStringFromTag(name.tag.upCast()) + "Type parameter name " + name.toString() + " is dupplicated";
				
			case IdlReadErrorKind.InvalidPackage(expected, actual):
				getRangeStringFromTag(actual.tag.upCast()) + "Package name " + expected.toString() + " is expected but " + actual.toString();
				
			case IdlReadErrorKind.TypeNotFound(path):
				getRangeStringFromTag(path.tag.upCast()) + "Type " + path.toString() + " is not found";
				
			case IdlReadErrorKind.ModuleNotFound(path):
				getRangeStringFromTag(path.tag.upCast()) + "Module " + path.toString() + " is not found";
				
			case IdlReadErrorKind.InvalidTypeParameterLength(path, expected, actual):
                getRangeStringFromTag(path.tag.upCast()) + "Type " + path.toString() + " parameter length is " + expected + " expected but actual " + actual;
				
			case IdlReadErrorKind.LoopedNewtype(path):
				getRangeStringFromTag(path.tag.upCast()) + "NewType " + path.toString() + " is loop";
                
            case IdlReadErrorKind.InvalidTypeDependenceDescription(litll):
                getRangeStringFromTag(LitllTools.getTag(litll).upCast()) + "Invalid " + Printer.printLitll(litll) + " is loop";
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
