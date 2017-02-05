package litll.idl.std.error;
import litll.core.error.LitllErrorSummary;
import litll.idl.std.data.idl.ArgumentName;
using litll.core.ds.MaybeTools;

class ArgumentSuffixError
{
    private var kind:ArgumentSuffixErrorKind;
    private var name:ArgumentName;
    
    public function new(name:ArgumentName, kind:ArgumentSuffixErrorKind) 
    {
        this.name = name;
        this.kind = kind;
    }
    
    public function getSummary():LitllErrorSummary
    {
        return LitllErrorSummary.createWithTag(name.tag.upCast(), ArgumentSuffixErrorKindTools.toString(kind));
    }
}