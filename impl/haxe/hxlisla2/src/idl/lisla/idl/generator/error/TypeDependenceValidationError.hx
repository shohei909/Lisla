package arraytree.idl.generator.error;
import haxe.ds.Option;
import arraytree.data.meta.position.Range;
import arraytree.error.core.ElementaryError;
import arraytree.error.core.ErrorName;
import arraytree.error.core.InlineError;
import arraytree.idl.generator.error.TypeDependenceValidationErrorKind;
import arraytree.idl.std.entity.idl.TypeDependenceName;

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
