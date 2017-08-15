package lisla.idl.lisla2entity.error;
import haxe.ds.Option;
import lisla.data.meta.position.Range;
import lisla.data.tree.al.AlTree;
import lisla.error.core.ElementaryError;
import lisla.error.core.ErrorName;
import lisla.error.core.InlineError;

class LislaToEntityError 
    implements InlineError
    implements ElementaryError
{
	public var kind(default, null):LislaToEntityErrorKind;
	
	public function new (
        kind:LislaToEntityErrorKind
        
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
			case LislaToEntityErrorKind.UnmatchedEnumConstructor(expected):
				"unmatched enum constructor. '" + expected.join(" | ") + "' expected";
				
			case LislaToEntityErrorKind.UnmatchedStructElement(expected):
				"unmatched struct element. '" + expected.join(" | ") + "' expected";
                
			case LislaToEntityErrorKind.UnmatchedLabel(expected):
				"unmatched enum label. '" + expected + "' expected";
				
			case LislaToEntityErrorKind.StructElementDuplicated(name):
				"struct element '" + name + "' is duplicated";
                
			case LislaToEntityErrorKind.StructElementNotFound(name):
				"struct element '" + name + "' is not found";
				
			case LislaToEntityErrorKind.CantBeArray:
				"can't be array";
				
			case LislaToEntityErrorKind.CantBeString:
				"can't be string";
				
			case LislaToEntityErrorKind.TooLongArray:
				"too long array";
				
			case LislaToEntityErrorKind.EndOfArray:
				"end of array";
				
			case LislaToEntityErrorKind.Fatal(message):
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
    public static function ofLisla(lisla:AlTree<String>, kind:LislaToEntityErrorKind):Array<LislaToEntityError>
    {
        return [new LislaToEntityError(kind)];
    }
}
