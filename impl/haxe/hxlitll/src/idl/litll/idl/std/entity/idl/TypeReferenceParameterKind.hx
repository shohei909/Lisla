package lisla.idl.std.entity.idl;
import lisla.core.Lisla;
import lisla.core.LislaString;

enum TypeReferenceParameterKind 
{
    Type(type:TypeReference);
    Dependence(data:TypeReferenceDependenceKind, type:TypeReference);
}
