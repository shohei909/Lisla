package lisla.idl.code.tools;
import lisla.data.meta.core.WithTag;
import lisla.idl.code.library.CodeTypeName;
import lisla.idl.code.library.CodeTypeNameDeclaration;
import lisla.idl.library.ModuleToCodeContext;
import lisla.type.lisla.type.TypeName;
import lisla.type.lisla.type.TypeNameDeclaration;
import lisla.type.lisla.type.TypeParameterDeclaration;

class TypeNameDeclarationToCode
{
    public static function getName(declaration:WithTag<TypeNameDeclaration>):WithTag<TypeName>
    {
        return switch (declaration.data)
        {
            case TypeNameDeclaration.Generic(_declaration):
                _declaration.name;
                
            case TypeNameDeclaration.Primitive(name):
                declaration.convert(name);
        }
    }
    
    public static function getParameters(declaration:WithTag<TypeNameDeclaration>):Array<WithTag<TypeParameterDeclaration>>
    {
        return switch (declaration.data)
        {
            case TypeNameDeclaration.Generic(_declaration):
                _declaration.parameters;
                
            case TypeNameDeclaration.Primitive(name):
                [];
        }
    }
    
    public static function toCode(
        declaration:WithTag<TypeNameDeclaration>,
        context:ModuleToCodeContext
    ):WithTag<CodeTypeNameDeclaration>
    {
        return declaration.convert(
            new CodeTypeNameDeclaration(
                TypeNameToCode.toCode(getName(declaration), context),
                switch (declaration.data)
                {
                    case TypeNameDeclaration.Generic(_declaration):
                        [for (parameter in _declaration.parameters)
                            TypeParameterDeclarationToCode.toCode(parameter, context)
                        ];
                        
                    case TypeNameDeclaration.Primitive(name):
                        [];
                }
            )
        );
    }
}
