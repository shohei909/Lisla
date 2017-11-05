package lisla.type.lisla.type;
import lisla.data.meta.core.WithTag;

class StructDeclaration 
{
    public var name:WithTag<TypeNameDeclaration>;
    public var elements:Array<WithTag<StructElement>>;
    
    public function new(
        name:WithTag<TypeNameDeclaration>,
        elements:Array<WithTag<StructElement>>
    ) 
    {
        this.name = name;
        this.elements = elements;
    }
}