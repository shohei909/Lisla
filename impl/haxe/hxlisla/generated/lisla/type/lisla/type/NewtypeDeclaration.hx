package lisla.type.lisla.type;
import lisla.data.meta.core.WithTag;

class NewtypeDeclaration 
{
    public var name:WithTag<TypeNameDeclaration>;
    public var underlyType:WithTag<TypeReference>;
    
    public function new(
        name:WithTag<TypeNameDeclaration>,
        underlyType:WithTag<TypeReference>
    ) 
    {
        this.name = name;
        this.underlyType = underlyType;
    }
}