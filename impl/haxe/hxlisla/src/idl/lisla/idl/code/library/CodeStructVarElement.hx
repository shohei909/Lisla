package lisla.idl.code.library;
import lisla.data.meta.core.WithTag;
import lisla.type.lisla.type.StructVarAttributes;
import lisla.type.lisla.type.TypeReference;
import lisla.type.lisla.type.VariableName;

class CodeStructVarElement 
{
    private var name:WithTag<CodeVariableName>;
    private var type:WithTag<CodeTypeReference>;
    private var attributes:WithTag<StructVarAttributes>;

    public function new(
        name:WithTag<CodeVariableName>,
        type:WithTag<CodeTypeReference>,
        attributes:WithTag<StructVarAttributes>
    ) {
        this.name = name;
        this.type = type;
        this.attributes = attributes;
    }
}
