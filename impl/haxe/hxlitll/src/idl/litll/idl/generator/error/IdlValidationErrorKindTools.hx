package litll.idl.generator.error;
import hxext.ds.Maybe;
import litll.core.error.InlineErrorSummary;
import litll.core.tag.Tag;
import litll.idl.std.entity.idl.TypePath;
import litll.idl.std.error.GetConditionErrorKind;
import litll.idl.std.error.GetConditionErrorKindTools;
import litll.idl.std.error.TypeFollowErrorKind;

class IdlValidationErrorKindTools
{
	public static function getSummary(errorKind:IdlValidationErrorKind):InlineErrorSummary<IdlValidationErrorKind>
	{
        inline function summary(tag:Maybe<Tag>, message:String):InlineErrorSummary<IdlValidationErrorKind>
        {
            return new InlineErrorSummary(
                tag.getRange(), 
                message,
                errorKind
            );
        }
        
		return switch (errorKind)
		{
            case IdlValidationErrorKind.GetCondition(error):
                GetConditionErrorKindTools.getSummary(error).map(IdlValidationErrorKind.GetCondition);
                
			case IdlValidationErrorKind.ArgumentNameDuplicated(name):
				summary(name.tag.upCast(), "Argument name " + name.name + " is duplicated");
				
			case IdlValidationErrorKind.EnumConstuctorNameDuplicated(name0, name1):
				summary(name0.tag.upCast(), "Enum constructor name " + name0.name + " is duplicated");
				
			case IdlValidationErrorKind.EnumConstuctorConditionDuplicated(name0, name1):
				summary(name0.tag.upCast(), "Enum constructor conditions is duplicated between " + name0.name + " and " + name1.name);
                
			case IdlValidationErrorKind.StructElementNameDuplicated(name0, name1):
				summary(name0.tag.upCast(), "Struct field name " + name0.name + " is duplicated");
				
			case IdlValidationErrorKind.StructElementConditionDuplicated(name0, name1):
				summary(name0.tag.upCast(), "Struct element conditions is duplicated between " + name0.name + " and " + name1.name);
                
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
