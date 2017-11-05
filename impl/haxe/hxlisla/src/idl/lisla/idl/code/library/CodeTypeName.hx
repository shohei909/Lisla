package lisla.idl.code.library;
import lisla.data.meta.core.WithTag;
import lisla.type.lisla.type.TypeName;

class CodeTypeName
{
    public var idlName:WithTag<TypeName>;
    public var codeName:WithTag<String>;
        
    public function new(
        idlName:WithTag<TypeName>,
        codeName:WithTag<String>
    ) 
    {
        this.idlName = idlName;
        this.codeName = codeName;
    }
}