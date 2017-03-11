package litll.idl.std.error;
import litll.core.error.ErrorTools;
import litll.core.error.InlineErrorSummary;
import litll.idl.std.data.idl.EnumConstructorName;

class EnumConstructorSuffixError 
{
    private var kind:EnumConstructorSuffixErrorKind;
    private var name:EnumConstructorName;
    
    public function new(name:EnumConstructorName, kind:EnumConstructorSuffixErrorKind) 
    {
        this.name = name;
        this.kind = kind;
    }
    
    public function getSummary():InlineErrorSummary<EnumConstructorSuffixErrorKind>
    {
        return new InlineErrorSummary(
            name.tag.getRange(),
            EnumConstructorSuffixErrorKindTools.toString(kind),
            kind
        );
    }
}
