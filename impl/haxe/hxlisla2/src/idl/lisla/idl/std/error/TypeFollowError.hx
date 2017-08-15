package lisla.idl.std.error;
import haxe.ds.Option;
import lisla.data.meta.position.Range;
import lisla.error.core.ElementaryError;
import lisla.error.core.ErrorName;
import lisla.error.core.InlineError;
import lisla.idl.exception.IdlException;

class TypeFollowError 
    implements InlineError
    implements ElementaryError
{
    public var kind:TypeFollowErrorKind;
    public function new(
        kind:TypeFollowErrorKind
        // TODO: 
        // range:Option<Range>
    )
    {
        this.kind = kind;
    }
    
    public function getMessage():String
    {
        return switch(kind)
        {
            case TypeFollowErrorKind.InvalidTypeParameterLength(typePath, expected, actual):
                "Type parameters length is invalid. " + typePath.toString() + " expects " + expected + ", but actual " + actual;
                
            case TypeFollowErrorKind.LoopedNewtype(typePath):
                "Type " + typePath.toString() + " is looping.";
        }
    }
    
    public function getErrorName():ErrorName
    {
        return ErrorName.fromEnum(kind);
    }
    
    public static function toIdlException(error:TypeFollowError):IdlException
    {
        return new IdlException(error.getMessage());
    }
    
    public function getOptionRange():Option<Range>
    {
        // FIXME: 
        return Option.None;
    }
    
    public function getInlineError():InlineError
    {
        return this;
    }
    
    public function getElementaryError():ElementaryError
    {
        return this;
    }
}
