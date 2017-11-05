package lisla.idl.code.tools;
import lisla.idl.code.library.CodeEnumCaseElement;
import lisla.idl.library.ModuleToCodeContext;
import lisla.type.lisla.type.EnumCaseElement;

class EnumCaseElementToCode {
    public static function toCode(
        value:EnumCaseElement, 
        context:ModuleToCodeContext
    ):CodeEnumCaseElement
    {
        return new CodeEnumCaseElement(
            VariableNameToCode.toCode(value.name, context),
            value.attributes
        );
    }
}
