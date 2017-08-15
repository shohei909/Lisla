package lisla.idl.generator.error;
import haxe.ds.Option;
import lisla.data.meta.position.Range;
import lisla.error.core.ElementaryError;
import lisla.error.core.ErrorName;
import lisla.error.core.InlineError;
import lisla.idl.generator.error.TypeDependenceValidationErrorKind;
import lisla.idl.std.entity.idl.TypeDependenceName;

class TypeDependenceValidationError
    implements ElementaryError
    implements InlineError
{
    private var kind:TypeDependenceValidationErrorKind;
    private var name:TypeDependenceName;
    
    public function new(
        kind:TypeDependenceValidationErrorKind,
        name:TypeDependenceName
    ) 
    {
        this.name = name;
        this.kind = kind;
    }
    
    public function getMessage():String
    {
        return switch(kind)
        {
			case TypeDependenceValidationErrorKind.NameDuplicated:
				"Type dependent name " + name.data + " is duplicated";
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
