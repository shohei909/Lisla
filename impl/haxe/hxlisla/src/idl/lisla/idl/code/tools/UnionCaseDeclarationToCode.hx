package lisla.idl.code.tools;
import lisla.idl.code.library.CodeUnionCaseElement;
import lisla.idl.code.library.CodeUnionElement;
import lisla.idl.library.ModuleToCodeContext;
import lisla.type.lisla.type.UnionCaseElement;
import lisla.type.lisla.type.UnionElement;

class UnionCaseDeclarationToCode 
{
    public static function toCode(
        value:UnionCaseElement, 
        context:ModuleToCodeContext
    ):CodeUnionCaseElement
    {
        return new CodeUnionCaseElement(
            VariantNameToCode.toCode(value.name, context),
            TypeReferenceToCode.toCode(value.type, context),
            value.attributes
        );
    }
    
}