package lisla.idl.code.tools;
import lisla.data.meta.core.WithTag;
import lisla.idl.code.library.CodeValueTypeParameterDeclaration;
import lisla.idl.library.ModuleToCodeContext;
import lisla.type.lisla.type.TypeParameterDeclaration;
import lisla.type.lisla.type.ValueTypeParameterDeclaration;
import lisla.type.lisla.type.VariableName;

class ValueTypeParameterDeclarationToCode 
{   
    public static function toCode(
        value:ValueTypeParameterDeclaration,
        context:ModuleToCodeContext
    ):CodeValueTypeParameterDeclaration
    {
        return new CodeValueTypeParameterDeclaration(
            VariableNameToCode.toCode(value.name, context),
            TypeReferenceToCode.toCode(value.type, context),
            value.attributes
        );
    }
}
