package lisla.idl.code.library;
import lisla.data.meta.core.WithTag;
import lisla.type.lisla.type.TupleVarAttributes;

class CodeTupleVarElement 
{
    public var name:WithTag<CodeVariableName>;
    public var type:WithTag<CodeTypeReference>;
    public var attributes:WithTag<TupleVarAttributes>;
    
    public function new(
        name:WithTag<CodeVariableName>,
        type:WithTag<CodeTypeReference>,
        attributes:WithTag<TupleVarAttributes>
    ) {
        this.name = name;
        this.type = type;
        this.attributes = attributes;
    }
}