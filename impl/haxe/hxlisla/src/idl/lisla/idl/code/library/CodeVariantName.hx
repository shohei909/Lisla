package lisla.idl.code.library;
import lisla.data.meta.core.WithTag;
import lisla.type.lisla.type.VariableName;
import lisla.type.lisla.type.VariantName;

class CodeVariantName 
{
    public var idlName:WithTag<VariantName>;
    public var codeName:WithTag<String>;
        
    public function new(
        idlName:WithTag<VariantName>,
        codeName:WithTag<String>
    ) 
    {
        this.idlName = idlName;
        this.codeName = codeName;
    }    
}
