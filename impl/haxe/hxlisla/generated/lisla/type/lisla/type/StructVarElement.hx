package lisla.type.lisla.type;
import lisla.data.meta.core.WithTag;

class StructVarElement 
{
    public var name:WithTag<VariableName>;
    public var type:WithTag<TypeReference>;
    public var attributes:WithTag<StructVarAttributes>;

    public function new(
        name:WithTag<VariableName>,
        type:WithTag<TypeReference>,
        attributes:WithTag<StructVarAttributes>
    ) {
        this.name = name;
        this.type = type;
        this.attributes = attributes;
    }
}
