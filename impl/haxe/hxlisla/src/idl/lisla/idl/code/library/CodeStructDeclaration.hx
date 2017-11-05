package lisla.idl.code.library;
import lisla.data.meta.core.WithTag;
import lisla.type.lisla.type.ConstElement;
import lisla.type.lisla.type.StructElement;
import lisla.type.lisla.type.StructVarElement;

class CodeStructDeclaration 
{
    public var elements:Array<WithTag<CodeStructElement>>;
    
    public function new(
        elements:Array<WithTag<CodeStructElement>>
    ) 
    {
        this.elements = elements;
    }
}
