package lisla.idl.generator.error;
import lisla.error.core.InlineError;
import lisla.error.core.InlineErrorHolder;
import lisla.idl.std.entity.idl.TypePath;
import lisla.idl.std.error.GetConditionError;
import lisla.idl.std.error.GetConditionErrorKind;
import lisla.idl.std.error.TypeFollowError;
import lisla.idl.std.error.TypeFollowErrorKind;

class IdlValidationError implements InlineErrorHolder
{
    public var kind:IdlValidationErrorKind;
    
    public function new(kind:IdlValidationErrorKind)
    {
        this.kind = kind;
    }
    
	public function getInlineError():InlineError
	{
		return switch (kind)
		{
            case IdlValidationErrorKind.GetCondition(error):
                error.getInlineError();
                
            case IdlValidationErrorKind.StructElement(error):
                error.getInlineError();
                
            case IdlValidationErrorKind.EnumConstuctor(error):
                error.getInlineError();
                
            case IdlValidationErrorKind.TypeDependence(error):
                error.getInlineError();
                
            case IdlValidationErrorKind.Argument(error):
                error.getInlineError();
        }
    }
    
    public static function createInvalidTypeParameterLength(
        typePath:TypePath, 
        expected:Int, 
        actual:Int
    ):IdlValidationError
    {
        var typeFollowError = new TypeFollowError(TypeFollowErrorKind.InvalidTypeParameterLength(typePath, expected, actual));
        var getConditionError = new GetConditionError(GetConditionErrorKind.Follow(typeFollowError));
        return new IdlValidationError(IdlValidationErrorKind.GetCondition(getConditionError));
    }
}
