package lisla.idl.code.tools;
import lisla.data.meta.core.MaybeTag;
import lisla.data.meta.core.WithTag;
import lisla.idl.code.library.CodeDeclaration;
import lisla.idl.code.library.CodeTupleDeclaration;
import lisla.idl.code.library.CodeType;
import lisla.idl.code.tools.TupleElementToCode;
import lisla.idl.library.ModuleToCodeContext;
import lisla.type.lisla.type.TupleDeclaration;

class TupleDeclarationToCode 
{
    public static function toCode(
        declaration:TupleDeclaration,
        tag:MaybeTag,
        context:ModuleToCodeContext
    ):CodeType
    {
        return new WithTag(
            new CodeType(
                TypeNameDeclarationToCode.getParameters(
                    declaration.data.name
                ),
                toCodeDeclaration(declaration, context)
            ),
            tag
        );
    }

    public static function toCodeDeclaration(
        declaration:TupleDeclaration,
        tag:MaybeTag,
        context:ModuleToCodeContext
    ):WithTag<CodeDeclaration> {
        return new WithTag(
            CodeDeclaration.Tuple(
                new CodeTupleDeclaration(
                    [for (element in declaration.data.elements) 
                        TupleElementToCode.toCode(
                            element,
                            context
                        )
                    ]
                )
            ),
            tag
        );
    }
}
