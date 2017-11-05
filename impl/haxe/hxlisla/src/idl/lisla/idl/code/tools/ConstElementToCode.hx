package lisla.idl.code.tools;
import lisla.idl.code.library.CodeConstElement;
import lisla.idl.library.ModuleToCodeContext;
import lisla.type.lisla.type.ConstElement;

class ConstElementToCode 
{
    public static function toCode(
        value:ConstElement, 
        context:ModuleToCodeContext
    ):CodeConstElement
    {
        return new CodeConstElement(
            VariableNameToCode.toCode(value.name, context),
            value.const
        );
    }
}
