package lisla.idl.std.error;
import lisla.error.core.InlineError;
import lisla.error.core.InlineErrorHolder;
import lisla.idl.exception.IdlException;

class GetConditionError implements InlineErrorHolder 
{
    public var kind:GetConditionErrorKind;
    public function new(kind:GetConditionErrorKind)
    {
        this.kind = kind;
    }
    
    public function getInlineError():InlineError
    {
        return switch(kind)
        {
            case GetConditionErrorKind.Follow(error):
                error;
                
            case GetConditionErrorKind.TupleArgumentSuffix(error):
                error;
                
            case GetConditionErrorKind.EnumConstructorSuffix(error):
                error;
                
            case GetConditionErrorKind.StructFieldSuffix(error):
                error;
        }
    }
    
    public static function toIdlException(error:GetConditionError):IdlException
    {
        return new IdlException(
            error.getInlineError().getElementaryError().getMessage()
        );
    }
}
