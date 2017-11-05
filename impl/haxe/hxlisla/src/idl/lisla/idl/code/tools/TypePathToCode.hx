package lisla.idl.code.tools;
import lisla.data.meta.core.WithTag;
import lisla.idl.code.library.CodeTypePath;
import lisla.idl.library.ModuleToCodeContext;
import lisla.type.lisla.type.TypePath;

class TypePathToCode 
{
    public static function toCode(
        value:WithTag<TypePath>, 
        context:ModuleToCodeContext
    ):WithTag<CodeTypePath>
    {
        return value.convert(
            new CodeTypePath(
                value.map(context.resolveTypePath),
                value.map(context.renameTypePath)
            )
        );
    }
}
