package lisla.idl.std.error;
import haxe.macro.Expr.TypeDefinition;
import lisla.idl.std.entity.idl.TypeName;
import lisla.idl.std.entity.idl.TypePath;
import lisla.idl.std.entity.idl.TypeReference;

enum TypeFollowErrorKind 
{
    InvalidTypeParameterLength(typePath:TypePath, expected:Int, actual:Int);
    LoopedNewtype(typePath:TypePath);
}