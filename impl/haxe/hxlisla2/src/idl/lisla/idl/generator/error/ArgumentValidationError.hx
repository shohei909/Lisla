package arraytree.idl.generator.error;
import haxe.ds.Option;
import arraytree.data.meta.position.Range;
import arraytree.error.core.ElementaryError;
import arraytree.error.core.ErrorName;
import arraytree.error.core.InlineError;
import arraytree.idl.std.entity.idl.ArgumentName;

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