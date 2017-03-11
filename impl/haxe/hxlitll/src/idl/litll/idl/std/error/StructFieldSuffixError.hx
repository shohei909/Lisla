package litll.idl.std.error;
import hxext.ds.Maybe;
import litll.core.error.InlineErrorSummary;
import litll.idl.std.entity.idl.StructElementName;

class StructFieldSuffixError 
{
    private var kind:StructFieldSuffixErrorKind;
    private var name:StructElementName;
    
    public function new(name:StructElementName, kind:StructFieldSuffixErrorKind) 
    {
        this.name = name;
        this.kind = kind;
    }
    
    public function getSummary():InlineErrorSummary<StructFieldSuffixErrorKind>
    {
        return new InlineErrorSummary(
            name.tag.getRange(),
            StructFieldSuffixErrorKindTools.toString(kind),
            kind
        );
    }
}
