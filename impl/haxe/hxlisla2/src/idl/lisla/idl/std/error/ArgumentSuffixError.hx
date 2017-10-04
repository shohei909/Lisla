package arraytree.idl.std.error;
import haxe.ds.Option;
import arraytree.data.meta.position.Range;
import arraytree.error.core.ElementaryError;
import arraytree.error.core.ErrorName;
import arraytree.error.core.InlineError;
import arraytree.idl.std.entity.idl.ArgumentName;

class ArgumentSuffixError 
    implements InlineError
    implements ElementaryError
{
    private var kind:ArgumentSuffixErrorKind;
    private var name:ArgumentName;
    
    public function new(
        name:ArgumentName, 
        kind:ArgumentSuffixErrorKind
        // TODO: 
        // range:Option<Range>
    ) 
    {
        this.name = name;
        this.kind = kind;
    }
    
    public function getMessage():String
    {
        return switch(kind)
        {
            case ArgumentSuffixErrorKind.InlineString:
                "string can't be inlined";
                
            case ArgumentSuffixErrorKind.UnsupportedDefault(kind):
                "Default is unsupported for value kind " + kind + ".";
                
            case ArgumentSuffixErrorKind.FirstElementRequired:
                "First element is required for the argument's type.";
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
    
    public function getInlineError():InlineError
    {
        return this;
    }
    
    public function getElementaryError():ElementaryError
    {
        return this;
    }
}
