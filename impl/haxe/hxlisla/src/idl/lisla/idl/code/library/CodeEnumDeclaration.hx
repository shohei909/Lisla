package lisla.idl.code.library;
import lisla.data.meta.core.WithTag;

class CodeEnumDeclaration 
{
    public var elements:Array<WithTag<CodeEnumElement>>;
    
    public function new(elements:Array<WithTag<CodeEnumElement>>)
    {
        this.elements = elements;
    }
}
