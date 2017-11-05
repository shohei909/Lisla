package lisla.idl.code.library;
import lisla.data.meta.core.WithTag;
import lisla.type.lisla.type.VariableName;

class CodeVariableName 
{
    public var idlName:WithTag<VariableName>;
    public var codeName:WithTag<String>;
        
    public function new(
        idlName:WithTag<VariableName>,
        codeName:WithTag<String>
    ) 
    {
        this.idlName = idlName;
        this.codeName = codeName;
    }
}
