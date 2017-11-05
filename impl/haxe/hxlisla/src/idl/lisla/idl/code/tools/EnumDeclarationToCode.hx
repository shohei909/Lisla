package lisla.idl.code.tools;
import lisla.data.meta.core.WithTag;
import lisla.idl.code.library.CodeDeclaration;
import lisla.idl.code.library.CodeEnumDeclaration;
import lisla.idl.code.library.CodeType;
import lisla.idl.code.tools.TypeNameDeclarationToCode;
import lisla.idl.library.ModuleToCodeContext;
import lisla.type.lisla.type.EnumDeclaration;

class EnumDeclarationToCode 
{
    public static function toCode(
        declaration:WithTag<EnumDeclaration>, 
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
        declaration:WithTag<EnumDeclaration>, 
        context:ModuleToCodeContext
    ):WithTag<CodeDeclaration>
    {
        return declaration.convert(
            CodeDeclaration.Enum(
                new CodeEnumDeclaration(
                    [for (element in declaration.data.elements) 
                        EnumElementToCode.toCode(
                            element,
                            context
                        )
                    ]
                )
            )
        );
    }
}
