package lisla.idl.code.tools;
import lisla.data.meta.core.WithTag;
import lisla.idl.code.library.CodeVariableName;
import lisla.idl.code.library.CodeVariantName;
import lisla.idl.library.ModuleToCodeContext;
import lisla.type.lisla.type.VariantName;

class VariantNameToCode 
{
    public static function toCode(
        name:WithTag<VariantName>, 
        context:ModuleToCodeContext
    ):WithTag<CodeVariantName>
    {
        return name.convert(
            new CodeVariantName(
                name,
                name.convert(
                    context.renameVariant(name.data)
                )
            )
        );
    }
}