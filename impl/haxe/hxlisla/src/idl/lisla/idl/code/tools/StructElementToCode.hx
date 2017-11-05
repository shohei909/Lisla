package lisla.idl.code.tools;
import lisla.data.meta.core.WithTag;
import lisla.idl.code.library.CodeStructElement;
import lisla.idl.code.library.CodeUnionElement;
import lisla.idl.library.ModuleToCodeContext;
import lisla.type.lisla.type.StructElement;
import lisla.type.lisla.type.StructVarElement;

class StructElementToCode 
{
    public static function toCode(
        value:WithTag<StructElement>, 
        context:ModuleToCodeContext
    ):WithTag<CodeStructElement>
    {
        return value.convert(
            switch (value.data)
            {
                case StructElement.Const(_value):
                    CodeStructElement.Const(
                        ConstElementToCode.toCode(
                            _value,
                            context
                        )
                    );
                    
                case StructElement.Var(_value):
                    CodeStructElement.Var(
                        StructVarElementToCode.toCode(
                            _value,
                            context
                        )
                    );
            }
        );
    }
}
