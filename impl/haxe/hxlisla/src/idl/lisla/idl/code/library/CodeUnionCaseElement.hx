package lisla.idl.code.library;
import lisla.data.meta.core.WithTag;
import lisla.type.lisla.type.TypeReference;
import lisla.type.lisla.type.UnionCaseAttributes;
import lisla.type.lisla.type.VariantName;

class CodeUnionCaseElement 
{
    public var name:WithTag<CodeVariantName>;
    public var type:WithTag<CodeTypeReference>;
    public var attributes:WithTag<UnionCaseAttributes>;
    
    public function new(
        name:WithTag<CodeVariantName>,
        type:WithTag<CodeTypeReference>,
        attributes:WithTag<UnionCaseAttributes>
    ) 
    {
        this.attributes = attributes;
        this.type = type;
        this.name = name;
    }
}
