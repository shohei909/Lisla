package lisla.idl.code.library;
import lisla.data.meta.core.WithTag;
import lisla.type.lisla.type.TypeName;
import lisla.type.lisla.type.TypeParameterDeclaration;

class CodeType 
{
    public var valueParameters:Array<WithTag<TypeParameterDeclaration>>;
    public var declaration:WithTag<CodeDeclaration>;
    
    public function new(
        valueParameters:Array<WithTag<TypeParameterDeclaration>>,
        declaration:WithTag<CodeDeclaration>
    ) 
    {
        this.valueParameters = valueParameters;
        this.declaration = declaration;
    }
}