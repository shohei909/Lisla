package arraytree.idl.arraytree2entity.error;
import haxe.ds.Option;
import arraytree.data.meta.position.Range;
import arraytree.data.tree.al.AlTree;
import arraytree.error.core.ElementaryError;
import arraytree.error.core.ErrorName;
import arraytree.error.core.InlineError;

class ArrayTreeToEntityError 
    implements InlineError
    implements ElementaryError
{
	public var kind(default, null):ArrayTreeToEntityErrorKind;
	
	public function new (
        kind:ArrayTreeToEntityErrorKind
        
        // TODO: 
        // range:Option<Range>
    )
	{
		this.kind = kind;
	}
	
	public function getMessage():String
	{
		return switch (kind)
		{
			case ArrayTreeToEntityErrorKind.UnmatchedEnumConstructor(expected):
				"unmatched enum constructor. '" + expected.join(" | ") + "' expected";
				
			case ArrayTreeToEntityErrorKind.UnmatchedStructElement(expected):
				"unmatched struct element. '" + expected.join(" | ") + "' expected";
                
			case ArrayTreeToEntityErrorKind.UnmatchedLabel(expected):
				"unmatched enum label. '" + expected + "' expected";
				
			case ArrayTreeToEntityErrorKind.StructElementDuplicated(name):
				"struct element '" + name + "' is duplicated";
                
			case ArrayTreeToEntityErrorKind.StructElementNotFound(name):
				"struct element '" + name + "' is not found";
				
			case ArrayTreeToEntityErrorKind.CantBeArray:
				"can't be array";
				
			case ArrayTreeToEntityErrorKind.CantBeString:
				"can't be string";
				
			case ArrayTreeToEntityErrorKind.TooLongArray:
				"too long array";
				
			case ArrayTreeToEntityErrorKind.EndOfArray:
				"end of array";
				
			case ArrayTreeToEntityErrorKind.Fatal(message):
				message;
		}
	}
    
    public function getErrorName():ErrorName
    {
        return ErrorName.fromEnum(kind);
    }
    
    public function getOptionRange():Option<Range>
    {
        // FIXME: 
        return Option.None;
    }
    
    public function getElementaryError():ElementaryError
    {
        return this;
    }
    
    public function getInlineError():InlineError
    {
        return this;
    }
    
    @:deprecated
    public static function ofArrayTree(arraytree:AlTree<String>, kind:ArrayTreeToEntityErrorKind):Array<ArrayTreeToEntityError>
    {
        return [new ArrayTreeToEntityError(kind)];
    }
}
