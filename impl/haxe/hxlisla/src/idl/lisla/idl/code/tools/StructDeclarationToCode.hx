package lisla.idl.code.tools;
import lisla.data.meta.core.WithTag;
import lisla.idl.code.library.CodeDeclaration;
import lisla.idl.code.library.CodeStructDeclaration;
import lisla.idl.code.library.CodeType;
import lisla.idl.library.ModuleToCodeContext;
import lisla.type.lisla.type.StructDeclaration;

class StructDeclarationToCode 
{
    public static function toCode(
        declaration:WithTag<StructDeclaration>,
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
        declaration:WithTag<StructDeclaration>,
        context:ModuleToCodeContext
    ):WithTag<CodeDeclaration> {
        return declaration.convert(
            CodeDeclaration.Struct(
                new CodeStructDeclaration(
                    [for (element in declaration.data.elements) 
                        StructElementToCode.toCode(
                            element,
                            context
                        )
                    ]
                )
            )
        );
    }
}
