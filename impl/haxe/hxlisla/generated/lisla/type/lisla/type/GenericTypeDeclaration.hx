package lisla.type.lisla.type;
import haxe.macro.Type;
import lisla.data.meta.core.WithTag;

class GenericTypeDeclaration 
{
    public var name:WithTag<TypeName>;
    public var parameters:Array<WithTag<TypeParameterDeclaration>>;
    
    public function new(
        name:WithTag<TypeName>,
        parameters:Array<WithTag<TypeParameterDeclaration>>
    ) {
        this.name = name;
        this.parameters = parameters;
    }
}
