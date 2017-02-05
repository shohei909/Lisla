package litll.idl.std.error;
import haxe.macro.Expr.TypeDefinition;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.TypeReference;

enum TypeFollowErrorKind 
{
    InvalidTypeParameterLength(typePath:TypePath, expected:Int, actual:Int);
    LoopedNewtype(typePath:TypePath);
}