package lisla.type.lisla.type;
import lisla.data.meta.core.WithTag;

class TupleVarElement 
{
    public var name:WithTag<VariableName>;
    public var type:WithTag<TypeReference>;
    public var attributes:WithTag<TupleVarAttributes>;
    
    public function new(
        name:WithTag<VariableName>,
        type:WithTag<TypeReference>,
        attributes:WithTag<TupleVarAttributes>
    ) {
        this.name = name;
        this.type = type;
        this.attributes = attributes;
    }
}
