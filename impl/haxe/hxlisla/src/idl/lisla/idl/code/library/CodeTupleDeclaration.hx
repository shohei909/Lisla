package lisla.idl.code.library;
import lisla.data.meta.core.WithTag;

class CodeTupleDeclaration 
{
    public var elements:Array<WithTag<CodeTupleElement>>;

    public function new(
        elements:Array<WithTag<CodeTupleElement>>
    ) 
    {
        this.elements = elements;
    }
}