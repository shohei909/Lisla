package lisla.idl.code.tools;
import lisla.data.meta.core.WithTag;
import lisla.idl.code.library.CodeTupleVarElement;
import lisla.idl.code.library.CodeUnionElement;
import lisla.idl.library.ModuleToCodeContext;
import lisla.type.lisla.type.TupleVarElement;
import lisla.type.lisla.type.UnionElement;

class UnionElementToCode 
{
    public static function toCode(
        value:WithTag<UnionElement>, 
        context:ModuleToCodeContext
    ):WithTag<CodeUnionElement>
    {
        return value.convert(
            switch (value.data)
            {
                case UnionElement.Case(_value):
                    CodeUnionElement.Case(
                        UnionCaseDeclarationToCode.toCode(
                            _value,
                            context
                        )
                    );
            }
        );
    }
}
