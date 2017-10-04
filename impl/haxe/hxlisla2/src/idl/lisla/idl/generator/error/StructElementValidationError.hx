package arraytree.idl.generator.error;
import haxe.ds.Option;
import arraytree.data.meta.position.Range;
import arraytree.error.core.ElementaryError;
import arraytree.error.core.ErrorName;
import arraytree.error.core.InlineError;
import arraytree.idl.std.entity.idl.StructElementName;

class StructElementValidationError
    implements ElementaryError
    implements InlineError
{
    private var kind:StructElementValidationErrorKind;
    private var name:StructElementName;
    
    public function new(
        name:StructElementName, 
        kind:StructElementValidationErrorKind
    ) 
    {
        this.name = name;
        this.kind = kind;
    }
    
    public function getMessage():String
    {
        return switch(kind)
        {
			case StructElementValidationErrorKind.NameDuplicated(name1):
				"Struct field name " + name.name + " is duplicated";
				
			case StructElementValidationErrorKind.ConditionDuplicated(name1):
				"Struct element conditions is duplicated between " + name.name + " and " + name1.name;
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