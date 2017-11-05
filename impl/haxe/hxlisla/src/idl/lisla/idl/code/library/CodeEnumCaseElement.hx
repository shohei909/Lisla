package lisla.idl.code.library;
import lisla.data.meta.core.WithTag;
import lisla.type.lisla.type.EnumCaseAttributes;
import lisla.type.lisla.type.VariableName;

class CodeEnumCaseElement 
{
    public var name:WithTag<CodeVariableName>;
    public var attributes:WithTag<EnumCaseAttributes>;
    
    public function new(
        name:WithTag<CodeVariableName>,
        attributes:WithTag<EnumCaseAttributes>
    ) {
        this.name = name;
        this.attributes = attributes;
    }
}
