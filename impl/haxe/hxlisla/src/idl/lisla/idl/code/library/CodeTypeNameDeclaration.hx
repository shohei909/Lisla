package lisla.idl.code.library;
import lisla.data.meta.core.WithTag;
import lisla.type.lisla.type.TypeName;
import lisla.type.lisla.type.TypeParameterDeclaration;

class CodeTypeNameDeclaration 
{
    public var name:WithTag<CodeTypeName>;
    public var parameters:Array<WithTag<CodeTypeParameterDeclaration>>;
    
    public function new(
        name:WithTag<CodeTypeName>,
        parameters:Array<WithTag<CodeTypeParameterDeclaration>>
    ) {
        this.name = name;
        this.parameters = parameters;
    }
}
