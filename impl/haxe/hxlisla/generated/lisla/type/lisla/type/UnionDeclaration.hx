package lisla.type.lisla.type;
import hxext.ds.Maybe;
import lisla.data.meta.core.WithTag;

class UnionDeclaration 
{
    public var name:WithTag<TypeNameDeclaration>;
    public var elements:Array<WithTag<UnionElement>>;
    
    public function new(
        name:WithTag<TypeNameDeclaration>,
        elements:Array<WithTag<UnionElement>>
    ) 
    {
        this.name = name;
        this.elements = elements;
    }
}
