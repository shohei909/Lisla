package lisla.idl.code.library;
import lisla.data.meta.core.WithTag;
import lisla.type.lisla.type.TypeNameDeclaration;
import lisla.type.lisla.type.TypeReference;

class CodeNewtypeDeclaration 
{
    public var name:WithTag<CodeTypeNameDeclaration>;
    public var underlyType:WithTag<CodeTypeReference>;

    public function new(
        name:WithTag<CodeTypeNameDeclaration>,
        underlyType:WithTag<CodeTypeReference>
    ) 
    {
        this.name = name;
        this.underlyType = underlyType;
    }
}
