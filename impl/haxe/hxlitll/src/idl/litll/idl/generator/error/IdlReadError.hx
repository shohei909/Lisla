package litll.idl.generator.error;
import litll.core.LitllTools;
import litll.core.ds.Maybe;
import litll.core.ds.SourceRange;
import litll.core.error.LitllErrorSummary;
import litll.core.print.Printer;
import litll.core.tag.Tag;
import litll.idl.generator.error.IdlValidationErrorKindTools;
import litll.idl.generator.error.IdlValidationErrorKindTools;
import litll.idl.generator.error.IdlValidationErrorKindTools;
import litll.idl.generator.source.file.IdlFilePath;

class IdlReadError
{
	public var filePath(default, null):IdlFilePath;
	public var errorKind(default, null):IdlReadErrorKind;
	
	public function new(filePath:IdlFilePath, errorKind:IdlReadErrorKind) 
	{
		this.filePath = filePath;
		this.errorKind = errorKind;
	}
	
	public function getSummary():LitllErrorSummary
	{
        inline function summary(tag:Maybe<Tag>, message:String):LitllErrorSummary
        {
            return LitllErrorSummary.createWithTag(tag, message);
        }
        
		return switch (errorKind)
		{
			case IdlReadErrorKind.Parse(error):
				error.getSummary();
				
			case IdlReadErrorKind.Delitll(error):
				error.getSummary();
				
			case IdlReadErrorKind.ModuleDupplicated(module, existingPath):
                new LitllErrorSummary(Maybe.none(), "Module " + module.toString() + " is dupplicated with " + existingPath.toString());
				
			case IdlReadErrorKind.TypeNameDupplicated(typePath):
                summary(typePath.tag.upCast(), "Type " + typePath.toString() + " is dupplicated");
				
			case IdlReadErrorKind.TypeParameterNameDupplicated(name):
				summary(name.tag.upCast(), "Type parameter name " + name.toString() + " is dupplicated");
				
			case IdlReadErrorKind.InvalidPackage(expected, actual):
				summary(actual.tag.upCast(), "Package name " + expected.toString() + " is expected but " + actual.toString());
				
			case IdlReadErrorKind.TypeNotFound(path):
				summary(path.tag.upCast(), "Type " + path.toString() + " is not found");
				
			case IdlReadErrorKind.ModuleNotFound(path):
				summary(path.tag.upCast(), "Module " + path.toString() + " is not found");
                
            case IdlReadErrorKind.InvalidTypeDependenceDescription(litll):
                summary(LitllTools.getTag(litll).upCast(), "Invalid " + LitllTools.toString(litll) + " is loop");
                
            case IdlReadErrorKind.Validation(error):
                IdlValidationErrorKindTools.getSummary(error);
		}
	}
}
