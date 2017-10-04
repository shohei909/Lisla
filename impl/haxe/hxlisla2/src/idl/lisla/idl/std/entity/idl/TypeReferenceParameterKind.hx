package arraytree.idl.std.entity.idl;
import arraytree.data.tree.al.AlTree;
import arraytree.data.meta.core.StringWithMetadata;

enum TypeReferenceParameterKind 
{
    Type(type:TypeReference);
    Dependence(data:TypeReferenceDependenceKind, type:TypeReference);
}
