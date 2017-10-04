package arraytree.idl.std.error;
import haxe.macro.Expr.TypeDefinition;
import arraytree.idl.std.entity.idl.TypeName;
import arraytree.idl.std.entity.idl.TypePath;
import arraytree.idl.std.entity.idl.TypeReference;

enum TypeFollowErrorKind 
{
    InvalidTypeParameterLength(typePath:TypePath, expected:Int, actual:Int);
    LoopedNewtype(typePath:TypePath);
}