package lisla.idl.code.tools;
import lisla.data.meta.core.WithTag;
import lisla.idl.code.library.CodeEnumCaseElement;
import lisla.idl.code.library.CodeEnumDeclaration;
import lisla.idl.code.library.CodeEnumElement;
import lisla.idl.code.library.CodeType;
import lisla.idl.library.ModuleToCodeContext;
import lisla.type.lisla.type.EnumDeclaration;
import lisla.type.lisla.type.EnumElement;

class EnumElementToCode 
{
    public static function toCode(
        element:WithTag<EnumElement>, 
        context:ModuleToCodeContext
    ):WithTag<CodeEnumElement>
    {
        return element.convert(
            switch (element.data)
            {
                case EnumElement.Case(value):
                    CodeEnumElement.Case(
                        EnumCaseElementToCode.toCode(
                            value,
                            context
                        )
                    );
            }
        );
    }
}