package lisla.idl.code.generate.structure;
import haxe.display.Position;
import haxe.macro.Expr.Metadata;
import haxe.macro.Expr.TypeDefinition;
import haxe.macro.Printer;
import lisla.type.lisla.type.Declaration;
import lisla.type.lisla.type.Idl;

class StructureGenerator
{
    public static function run(
        context:StructureGenerateContext, 
        declaration:Declaration
    ):TypeDefinition
    {
        return switch (declaration)
        {
            case Declaration.Newtype():
            case Declaration.Enum():
                
            case Declaration.Union(type):
                UnionStructureGenerator.run(context, type);
                
            case Declaration.Tuple():
            case Declaration.Struct():
        }
    }
}
