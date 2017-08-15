package lisla.idl.generator.error;
import haxe.ds.Option;
import lisla.data.meta.position.Range;
import lisla.error.core.ElementaryError;
import lisla.error.core.ErrorName;
import lisla.error.core.InlineError;
import lisla.idl.std.entity.idl.ArgumentName;

class ArgumentValidationError
    implements ElementaryError
    implements InlineError
{
    private var kind:ArgumentValidationErrorKind;
    private var name:ArgumentName;
    
    public function new(
        kind:ArgumentValidationErrorKind,
        name:ArgumentName
    ) 
    {
        this.name = name;
        this.kind = kind;
    }
    
    public function getMessage():String
    {
        return switch(kind)
        {
			case ArgumentValidationErrorKind.NameDuplicated:
				"Argument name " + name.name + " is duplicated";
        }
    }   
    
    public function getErrorName():ErrorName
    {
        return ErrorName.fromEnum(kind);
    }
    
    public function getOptionRange():Option<Range>
    {
        return name.metadata.range;
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