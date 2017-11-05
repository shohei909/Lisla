package lisla.type.lisla.type;
import lisla.data.meta.core.WithTag;

class EnumDeclaration 
{
    public var name:WithTag<TypeNameDeclaration>;
    public var elements:Array<WithTag<EnumElement>>;
    
    public function new(
        name:WithTag<TypeNameDeclaration>,
        elements:Array<WithTag<EnumElement>>
    ) 
    {
        this.name = name;
        this.elements = elements;
    }
}
