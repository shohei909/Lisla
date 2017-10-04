package arraytree.idl.generator.error;
import arraytree.error.core.InlineError;
import arraytree.error.core.InlineErrorHolder;
import arraytree.idl.std.entity.idl.TypePath;
import arraytree.idl.std.error.GetConditionError;
import arraytree.idl.std.error.GetConditionErrorKind;
import arraytree.idl.std.error.TypeFollowError;
import arraytree.idl.std.error.TypeFollowErrorKind;

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
