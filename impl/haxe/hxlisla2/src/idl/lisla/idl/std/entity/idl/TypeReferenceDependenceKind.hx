package arraytree.idl.std.entity.idl;
import arraytree.data.tree.al.AlTree;

enum TypeReferenceDependenceKind 
{
    Const(arraytree:AlTree<String>);
    Reference(name:String);
}
