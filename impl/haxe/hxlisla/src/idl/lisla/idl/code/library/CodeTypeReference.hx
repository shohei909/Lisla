package lisla.idl.code.library;
import lisla.data.meta.core.WithTag;
import lisla.type.lisla.type.GenericTypeReference;
import lisla.type.lisla.type.TypeArgument;
import lisla.type.lisla.type.TypePath;

class CodeTypeReference 
{
    public var value:WithTag<CodeTypePath>;
    public var parameters:Array<WithTag<CodeTypeArgument>>;
    
    public function new(
        value:WithTag<CodeTypePath>,
        parameters:Array<WithTag<CodeTypeArgument>>
    )
    {
        this.value = value;
        this.parameters = parameters;
    }
}
