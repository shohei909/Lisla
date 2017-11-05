package lisla.idl.code.tools;
import lisla.idl.code.library.CodeStructVarElement;
import lisla.idl.library.ModuleToCodeContext;
import lisla.type.lisla.type.StructVarElement;

class StructVarElementToCode 
{
    public static function toCode(
        value:StructVarElement, 
        context:ModuleToCodeContext
    ):CodeStructVarElement
    {
        return new CodeStructVarElement(
            VariableNameToCode.toCode(value.name, context),
            TypeReferenceToCode.toCode(value.type, context),
            value.attributes
        );
    }
}
