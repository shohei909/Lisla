package litll.idl.std.entity.idl;
import litll.core.Litll;
import litll.core.LitllString;

enum TypeReferenceParameterKind 
{
    Type(type:TypeReference);
    Dependence(data:TypeReferenceDependenceKind, type:TypeReference);
}
