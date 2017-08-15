package lisla.idl.std.entity.idl;
import lisla.data.tree.al.AlTree;
import lisla.data.meta.core.StringWithMetadata;

enum TypeReferenceParameterKind 
{
    Type(type:TypeReference);
    Dependence(data:TypeReferenceDependenceKind, type:TypeReference);
}
