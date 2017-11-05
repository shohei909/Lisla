package lisla.idl.code.tools;
import lisla.data.meta.core.WithTag;
import lisla.idl.code.library.CodeTypeParameterDeclaration;
import lisla.idl.library.ModuleToCodeContext;
import lisla.type.lisla.type.TypeParameterDeclaration;

class TypeParameterDeclarationToCode 
{
    public static function toCode(
        value:WithTag<TypeParameterDeclaration>,
        context:ModuleToCodeContext
    ):WithTag<CodeTypeParameterDeclaration>
    {
        return value.convert(
            switch (value.data)
            {
                case TypeParameterDeclaration.Value(_value):
                    CodeTypeParameterDeclaration.Value(
                        ValueTypeParameterDeclarationToCode.toCode(_value, context)
                    );
                case TypeParameterDeclaration.Type(_value):
                    CodeTypeParameterDeclaration.Type(
                        TypeTypeParameterDeclarationToCode.toCode(_value, context)
                    );
            }
        );
    }   
}