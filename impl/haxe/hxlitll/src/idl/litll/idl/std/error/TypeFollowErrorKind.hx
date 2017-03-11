package litll.idl.std.error;
import haxe.macro.Expr.TypeDefinition;
import litll.idl.std.entity.idl.TypeName;
import litll.idl.std.entity.idl.TypePath;
import litll.idl.std.entity.idl.TypeReference;

enum TypeFollowErrorKind 
{
    InvalidTypeParameterLength(typePath:TypePath, expected:Int, actual:Int);
    LoopedNewtype(typePath:TypePath);
}