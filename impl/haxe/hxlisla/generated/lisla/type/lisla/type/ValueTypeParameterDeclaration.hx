package lisla.type.lisla.type;
import lisla.data.meta.core.WithTag;

class ValueTypeParameterDeclaration {
    public var name:WithTag<VariableName>;
    public var type:WithTag<TypeReference>;
    public var attributes:WithTag<TypeParameterDeclarationAttributes>;

    public function new(
        name:WithTag<VariableName>,
        type:WithTag<TypeReference>,
        attributes:WithTag<TypeParameterDeclarationAttributes>
    )
    {
        this.name = name;
        this.type = type;
        this.attributes = attributes;
    }
}
