package lisla.idl.std.error;
import lisla.core.error.ErrorTools;
import lisla.core.error.InlineErrorSummary;
import lisla.idl.std.entity.idl.EnumConstructorName;

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
