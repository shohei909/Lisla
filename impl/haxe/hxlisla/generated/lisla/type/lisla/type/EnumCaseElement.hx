package lisla.type.lisla.type;
import lisla.data.meta.core.WithTag;

class EnumCaseElement 
{
    public var name:WithTag<VariableName>;
    public var attributes:WithTag<EnumCaseAttributes>;
    
    public function new(
        name:WithTag<VariableName>,
        attributes:WithTag<EnumCaseAttributes>
    ) {
        this.name = name;
        this.attributes = attributes;
    }
}
