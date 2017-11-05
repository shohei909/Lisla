package lisla.idl.code.library;
import lisla.data.meta.core.WithTag;
import lisla.type.lisla.type.TypeParameterDeclarationAttributes;

class CodeTypeTypeParameterDeclaration 
{
    public var name:WithTag<CodeTypeName>;
    public var attributes:WithTag<TypeParameterDeclarationAttributes>;
    
    public function new(
        name:WithTag<CodeTypeName>,
        attributes:WithTag<TypeParameterDeclarationAttributes>
    )
    {
        this.name = name;
        this.attributes = attributes;
    }
}