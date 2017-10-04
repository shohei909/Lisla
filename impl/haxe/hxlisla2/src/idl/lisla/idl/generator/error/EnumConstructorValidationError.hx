package arraytree.idl.generator.error;
import haxe.ds.Option;
import arraytree.data.meta.position.Range;
import arraytree.error.core.ElementaryError;
import arraytree.error.core.ErrorName;
import arraytree.error.core.InlineError;
import arraytree.idl.std.entity.idl.EnumConstructorName;

class EnumConstructorValidationError
    implements ElementaryError
    implements InlineError
{
    private var kind:EnumConstructorValidationErrorKind;
    private var name:EnumConstructorName;
    
    public function new(
        kind:EnumConstructorValidationErrorKind,
        name:EnumConstructorName
    ) 
    {
        this.name = name;
        this.kind = kind;
    }
    
    public function getMessage():String
    {
        return switch(kind)
        {
			case EnumConstructorValidationErrorKind.NameDuplicated(name1):
				"Enum constructor name " + name.name + " is duplicated";
				
			case EnumConstructorValidationErrorKind.ConditionDuplicated(name1):
				"Enum constructor conditions is duplicated between " + name.name + " and " + name.name;
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