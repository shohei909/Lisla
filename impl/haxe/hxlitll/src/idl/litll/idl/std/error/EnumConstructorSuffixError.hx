package litll.idl.std.error;
import litll.core.error.LitllErrorSummary;
import litll.idl.std.data.idl.EnumConstructorName;
using litll.core.ds.MaybeTools;

class EnumConstructorSuffixError 
{
    private var kind:EnumConstructorSuffixErrorKind;
    private var name:EnumConstructorName;
    
    public function new(name:EnumConstructorName, kind:EnumConstructorSuffixErrorKind) 
    {
        this.name = name;
        this.kind = kind;
    }
    
    public function getSummary():LitllErrorSummary
    {
        return LitllErrorSummary.createWithTag(name.tag.upCast(), EnumConstructorSuffixErrorKindTools.toString(kind));
    }
}
