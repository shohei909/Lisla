package lisla.idl.code.tools;
import lisla.data.meta.core.WithTag;
import lisla.idl.code.library.CodeTupleElement;
import lisla.idl.code.library.CodeType;
import lisla.idl.library.ModuleToCodeContext;
import lisla.type.lisla.type.TupleDeclaration;
import lisla.type.lisla.type.TupleElement;

class TupleElementToCode 
{
    public static function toCode(
        value:WithTag<TupleElement>,
        context:ModuleToCodeContext
    ):WithTag<CodeTupleElement> 
    {
        return value.convert(
            switch (value.data)
            {
                case TupleElement.Label(_value):
                    CodeTupleElement.Label(_value);
                    
                case TupleElement.Var(_value):
                    CodeTupleElement.Var(
                        TupleVarElementToCode.toCode(
                            _value,
                            context
                        )
                    );
            }
        );
    }   
}
