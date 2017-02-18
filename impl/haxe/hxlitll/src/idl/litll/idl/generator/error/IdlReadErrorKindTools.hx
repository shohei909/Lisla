package litll.idl.generator.error;
import hxext.ds.Maybe;
import litll.core.LitllTools;
import litll.core.error.ErrorSummary;
import litll.core.error.LitllErrorSummary;
import litll.core.tag.Tag;
import litll.idl.litlltext2entity.error.LitllTextToEntityErrorKindTools;

class IdlReadErrorKindTools 
{
    public static function getSummary(errorKind:IdlReadErrorKind):ErrorSummary
	{
        inline function summary(tag:Maybe<Tag>, message:String):ErrorSummary
        {
            return LitllErrorSummary.createWithTag(tag, message);
        }
        
		return switch (errorKind)
		{
			case IdlReadErrorKind.LitllTextToEntity(error):
				LitllTextToEntityErrorKindTools.getSummary(error);
				
			case IdlReadErrorKind.ModuleDuplicated(module, existingPath):
                new LitllErrorSummary(Maybe.none(), "Module " + module.toString() + " is duplicated with " + existingPath.toString());
				
			case IdlReadErrorKind.TypeNameDuplicated(typePath):
                summary(typePath.tag.upCast(), "Type " + typePath.toString() + " is duplicated");
				
			case IdlReadErrorKind.TypeParameterNameDuplicated(name):
				summary(name.tag.upCast(), "Type parameter name " + name.toString() + " is duplicated");
				
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
