package lisla.idl.std.error;
import hxext.ds.Maybe;
import lisla.core.error.InlineErrorSummary;
import lisla.idl.std.entity.idl.ArgumentName;

class ArgumentSuffixError
{
    private var kind:ArgumentSuffixErrorKind;
    private var name:ArgumentName;
    
    public function new(name:ArgumentName, kind:ArgumentSuffixErrorKind) 
    {
        this.name = name;
        this.kind = kind;
    }
    
    public function getSummary():InlineErrorSummary<ArgumentSuffixErrorKind>
    {
        return new InlineErrorSummary(
            name.tag.getRange(), 
            ArgumentSuffixErrorKindTools.toString(kind),
            kind
        );
    }
}
