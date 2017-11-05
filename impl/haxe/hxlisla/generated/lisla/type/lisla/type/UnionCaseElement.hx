package lisla.type.lisla.type;
import lisla.data.meta.core.WithTag;

class UnionCaseElement 
{
    public var name:WithTag<VariantName>;
    public var type:WithTag<TypeReference>;
    public var attributes:WithTag<UnionCaseAttributes>;
    
    public function new(
        name:WithTag<VariantName>,
        type:WithTag<TypeReference>,
        attributes:WithTag<UnionCaseAttributes>
    ) 
    {
        this.attributes = attributes;
        this.type = type;
        this.name = name;
    }
}
