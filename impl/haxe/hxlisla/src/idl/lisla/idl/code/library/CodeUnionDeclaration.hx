package lisla.idl.code.library;
import lisla.data.meta.core.WithTag;
import lisla.type.lisla.type.UnionElement;

class CodeUnionDeclaration 
{
    public var elements:Array<WithTag<CodeUnionElement>>;
    public function new(
        elements:Array<WithTag<CodeUnionElement>>
    ) 
    {
        this.elements = elements;
    }    
}