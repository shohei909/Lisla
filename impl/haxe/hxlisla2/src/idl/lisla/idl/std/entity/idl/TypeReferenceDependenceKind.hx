package lisla.idl.std.entity.idl;
import lisla.data.tree.al.AlTree;

enum TypeReferenceDependenceKind 
{
    Const(lisla:AlTree<String>);
    Reference(name:String);
}
