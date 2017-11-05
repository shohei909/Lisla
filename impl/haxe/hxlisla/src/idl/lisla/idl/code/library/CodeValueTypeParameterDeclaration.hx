package lisla.idl.code.library;
import lisla.data.meta.core.WithTag;
import lisla.type.lisla.type.TypeParameterDeclarationAttributes;
import lisla.type.lisla.type.TypeReference;
import lisla.type.lisla.type.VariableName;

class CodeValueTypeParameterDeclaration 
{
    public var name:WithTag<CodeVariableName>;
    public var type:WithTag<CodeTypeReference>;
    public var attributes:WithTag<TypeParameterDeclarationAttributes>;
    
    public function new(
        name:WithTag<CodeVariableName>,
        type:WithTag<CodeTypeReference>,
        attributes:WithTag<TypeParameterDeclarationAttributes>
    ) 
    {
        this.name = name;
        this.type = type;
        this.attributes = attributes;
    }
    
}