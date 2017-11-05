package lisla.type.lisla.type;
import lisla.data.meta.core.WithTag;

class GenericTypeReference 
{
    public var name:WithTag<TypePath>;
    public var arguments:Array<WithTag<TypeArgument>>;
    
    public function new(
        name:WithTag<TypePath>,
        arguments:Array<WithTag<TypeArgument>>
    ) {
        this.name = name;
        this.arguments = arguments;
    }
}