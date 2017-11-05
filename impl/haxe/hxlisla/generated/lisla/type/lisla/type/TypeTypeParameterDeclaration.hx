package lisla.type.lisla.type;
import lisla.data.meta.core.WithTag;

class TypeTypeParameterDeclaration 
{
    public var name:WithTag<TypeName>;
    public var attributes:WithTag<TypeParameterDeclarationAttributes>;
    
    public function new(
        name:WithTag<TypeName>,
        attributes:WithTag<TypeParameterDeclarationAttributes>
    )
    {
        this.name = name;
        this.attributes = attributes;
    }
}
