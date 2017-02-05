package litll.idl.std.error;
import litll.core.error.LitllErrorSummary;
import litll.idl.std.data.idl.StructFieldName;
using litll.core.ds.MaybeTools;

class StructFieldSuffixError 
{
    private var kind:StructFieldSuffixErrorKind;
    private var name:StructFieldName;
    
    public function new(name:StructFieldName, kind:StructFieldSuffixErrorKind) 
    {
        this.name = name;
        this.kind = kind;
    }
    
    public function getSummary():LitllErrorSummary
    {
        return LitllErrorSummary.createWithTag(name.tag.upCast(), StructFieldSuffixErrorKindTools.toString(kind));
    }
}
