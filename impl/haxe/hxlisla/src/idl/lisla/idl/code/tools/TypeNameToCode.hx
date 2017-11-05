package lisla.idl.code.tools;
import lisla.data.meta.core.WithTag;
import lisla.idl.code.library.CodeTypeName;
import lisla.idl.library.ModuleToCodeContext;
import lisla.type.lisla.type.TypeName;

class TypeNameToCode 
{
    public static function toCode(
        name:WithTag<TypeName>, 
        context:ModuleToCodeContext
    ):WithTag<CodeTypeName>
    {
        return name.convert(
            new CodeTypeName(
                name,
                name.map(n -> context.renameType(n))
            )
        );
    }
}
