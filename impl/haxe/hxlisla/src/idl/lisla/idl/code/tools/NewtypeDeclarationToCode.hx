package lisla.idl.code.tools;
import lisla.data.meta.core.WithTag;
import lisla.idl.code.library.CodeDeclaration;
import lisla.idl.code.library.CodeNewtypeDeclaration;
import lisla.idl.code.library.CodeType;
import lisla.idl.library.ModuleToCodeContext;
import lisla.type.lisla.type.NewtypeDeclaration;

class NewtypeDeclarationToCode 
{
    public static function toCode(
        declaration:WithTag<NewtypeDeclaration>,
        context:ModuleToCodeContext
    ):WithTag<CodeType> 
    {
        return declaration.convert(
            new CodeType(
                TypeNameDeclarationToCode.getParameters(
                    declaration.data.name
                ),
                toCodeDeclaration(declaration, context)
            )
        );
    }

    public static function toCodeDeclaration(
        declaration:WithTag<NewtypeDeclaration>,
        context:ModuleToCodeContext
    ):WithTag<CodeDeclaration> {
        return declaration.convert(
            CodeDeclaration.Newtype(
                new CodeNewtypeDeclaration(
                    TypeNameDeclarationToCode.toCode(declaration.data.name, context),
                    TypeReferenceToCode.toCode(declaration.data.underlyType, context)
                )
            )
        );
    }
}
