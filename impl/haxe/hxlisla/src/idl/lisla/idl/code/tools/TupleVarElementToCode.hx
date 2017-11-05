package lisla.idl.code.tools;
import lisla.data.meta.core.WithTag;
import lisla.idl.code.library.CodeTupleVarElement;
import lisla.idl.library.ModuleToCodeContext;
import lisla.type.lisla.type.TupleVarElement;

class TupleVarElementToCode 
{
    public static function toCode(
        value:TupleVarElement, 
        context:ModuleToCodeContext
    ):CodeTupleVarElement
    {
        return new CodeTupleVarElement(
            VariableNameToCode.toCode(value.name, context),
            TypeReferenceToCode.toCode(value.type, context),
            value.attributes
        );
    }
}