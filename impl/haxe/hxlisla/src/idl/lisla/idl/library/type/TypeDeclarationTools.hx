package lisla.idl.library.type;
import haxe.macro.Context;
import lisla.data.meta.core.WithTag;
import lisla.idl.code.library.CodeDeclaration;
import lisla.idl.code.library.CodeTupleDeclaration;
import lisla.idl.code.library.CodeType;
import lisla.idl.code.tools.EnumDeclarationToCode;
import lisla.idl.code.tools.NewtypeDeclarationToCode;
import lisla.idl.code.tools.StructDeclarationToCode;
import lisla.idl.code.tools.TupleDeclarationToCode;
import lisla.idl.code.tools.TypeNameDeclarationToCode;
import lisla.idl.code.tools.UnionDeclarationToCode;
import lisla.idl.library.ModuleToCodeContext;
import lisla.type.lisla.type.Declaration;
import lisla.type.lisla.type.TypeName;
import lisla.type.lisla.type.TypeNameDeclaration;

class TypeDeclarationTools 
{
    public static function getNameDeclaration(declaration:TypeDeclaration):WithTag<TypeNameDeclaration>
    {
        return switch (declaration)
        {
            case TypeDeclaration.Tuple(value)  : value.name;
            case TypeDeclaration.Union(value)  : value.name;
            case TypeDeclaration.Newtype(value): value.name;
            case TypeDeclaration.Struct(value) : value.name;
            case TypeDeclaration.Enum(value)   : value.name;
        }
    }
    
    public static function getName(declaration:TypeDeclaration):WithTag<TypeName>
    {
        return TypeNameDeclarationToCode.getName(
            getNameDeclaration(declaration)
        );
    }

    public static function toCode(
        declaration:WithTag<TypeDeclaration>,
        context:ModuleToCodeContext
    ):WithTag<CodeType>
    {
        return switch (declaration.data)
        {
            case TypeDeclaration.Tuple(value): 
                TupleDeclarationToCode.toCode(value, context);

            case TypeDeclaration.Union(value): 
                UnionDeclarationToCode.toCode(value, context);
                
            case TypeDeclaration.Newtype(value):
                NewtypeDeclarationToCode.toCode(value, context);
                
            case TypeDeclaration.Struct(value):
                StructDeclarationToCode.toCode(value, context);
                
            case TypeDeclaration.Enum(value):
                EnumDeclarationToCode.toCode(value, context);
        }
    }
}
