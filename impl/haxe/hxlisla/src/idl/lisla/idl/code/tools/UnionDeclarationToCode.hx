package lisla.idl.code.tools;
import lisla.data.meta.core.WithTag;
import lisla.idl.code.library.CodeDeclaration;
import lisla.idl.code.library.CodeType;
import lisla.idl.code.library.CodeUnionDeclaration;
import lisla.idl.library.ModuleToCodeContext;
import lisla.type.lisla.type.UnionDeclaration;

class UnionDeclarationToCode 
{
    public static function toCode(
        declaration:WithTag<UnionDeclaration>,
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
        declaration:WithTag<UnionDeclaration>,
        context:ModuleToCodeContext
    ):WithTag<CodeDeclaration> {
        return declaration.convert(
            CodeDeclaration.Union(
                new CodeUnionDeclaration(
                    [for (element in declaration.data.elements) 
                        UnionElementToCode.toCode(
                            element,
                            context
                        )
                    ]
                )
            )
        );
    }
}
