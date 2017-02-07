package litll.idl.generator.error;
import litll.core.LitllTools;
import litll.core.ds.Maybe;
import litll.core.error.LitllErrorSummary;
import litll.core.tag.Tag;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.error.GetConditionErrorKind;
import litll.idl.std.error.GetConditionErrorKindTools;
import litll.idl.std.error.TypeFollowErrorKind;
import litll.idl.std.error.TypeFollowErrorKindTools;

class IdlValidationErrorKindTools
{
	public static function getSummary(errorKind:IdlValidationErrorKind ):LitllErrorSummary
	{
        inline function summary(tag:Maybe<Tag>, message:String):LitllErrorSummary
        {
            return LitllErrorSummary.createWithTag(tag, message);
        }
        
		return switch (errorKind)
		{
            case IdlValidationErrorKind.GetCondition(error):
                GetConditionErrorKindTools.getSummary(error);
                
			case IdlValidationErrorKind.ArgumentNameDuplicated(name):
				summary(name.tag.upCast(), "Argument name " + name.name + " is duplicated");
				
			case IdlValidationErrorKind.EnumConstuctorNameDuplicated(name):
				summary(name.tag.upCast(), "Enum constructor name " + name.name + " is duplicated");
				
			case IdlValidationErrorKind.EnumConstuctorConditionDuplicated(name0, name1):
				summary(name0.tag.upCast(), "Enum constructor condition is duplicated between " + name0.name + " and " + name1.name);
                
			case IdlValidationErrorKind.StructFieldNameDuplicated(name):
				summary(name.tag.upCast(), "Struct field name " + name.name + " is duplicated");
				
			case IdlValidationErrorKind.TypeDependenceNameDuplicated(name):
				summary(name.tag.upCast(), "Type dependent name " + name.data + " is duplicated");
        }
    }
    
    public static function createInvalidTypeParameterLength(typePath:TypePath, expected:Int, actual:Int):IdlValidationErrorKind
    {
        return IdlValidationErrorKind.GetCondition(
            GetConditionErrorKind.Follow(
                TypeFollowErrorKind.InvalidTypeParameterLength(
                    typePath, expected, actual
                )
            )
        );
    }
}
