package litll.idl.std.error;
import litll.core.error.LitllErrorSummary;
import litll.idl.std.data.idl.StructElementName;
using hxext.ds.MaybeTools;

class StructFieldSuffixError 
{
    private var kind:StructFieldSuffixErrorKind;
    private var name:StructElementName;
    
    public function new(name:StructElementName, kind:StructFieldSuffixErrorKind) 
    {
        this.name = name;
        this.kind = kind;
    }
    
    public function getSummary():LitllErrorSummary
    {
        return LitllErrorSummary.createWithTag(name.tag.upCast(), StructFieldSuffixErrorKindTools.toString(kind));
    }
}
