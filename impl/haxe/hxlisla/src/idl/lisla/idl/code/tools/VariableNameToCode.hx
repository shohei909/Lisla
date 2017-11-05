package lisla.idl.code.tools;
import lisla.data.meta.core.WithTag;
import lisla.idl.code.library.CodeVariableName;
import lisla.idl.library.ModuleToCodeContext;
import lisla.type.lisla.type.VariableName;

class VariableNameToCode 
{    
    public static function toCode(
        name:WithTag<VariableName>, 
        context:ModuleToCodeContext
    ):WithTag<CodeVariableName>
    {
        return name.convert(
            new CodeVariableName(
                name,
                name.convert(
                    context.renameVaraiable(name.data)
                )
            )
        );
    }
}
