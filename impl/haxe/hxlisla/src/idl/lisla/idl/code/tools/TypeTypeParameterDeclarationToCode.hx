package lisla.idl.code.tools;
import lisla.idl.code.library.CodeTypeTypeParameterDeclaration;
import lisla.idl.library.ModuleToCodeContext;
import lisla.type.lisla.type.TypeTypeParameterDeclaration;
import lisla.type.lisla.type.TypeTypeParameterDeclaration;

class TypeTypeParameterDeclarationToCode 
{
    public static function toCode(
        value:TypeTypeParameterDeclaration,
        context:ModuleToCodeContext
    ):CodeTypeTypeParameterDeclaration
    {
        return new CodeTypeTypeParameterDeclaration(
            TypeNameToCode.toCode(value.name, context),
            value.attributes
        );
    }
}