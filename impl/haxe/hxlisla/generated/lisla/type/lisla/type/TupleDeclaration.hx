package lisla.type.lisla.type;
import lisla.data.meta.core.WithTag;

class TupleDeclaration 
{
    public var name:WithTag<TypeNameDeclaration>;
    public var elements:Array<WithTag<TupleElement>>;
    
    public function new(
        name:WithTag<TypeNameDeclaration>,
        elements:Array<WithTag<TupleElement>>
    ) 
    {
        this.name = name;
        this.elements = elements;
    }
}
