package lisla.idl.code.library;
import lisla.type.lisla.type.EnumDeclaration;
import lisla.type.lisla.type.NewtypeDeclaration;
import lisla.type.lisla.type.StructDeclaration;
import lisla.type.lisla.type.TupleDeclaration;
import lisla.type.lisla.type.UnionDeclaration;

enum CodeDeclaration 
{
    Tuple(value:CodeTupleDeclaration);
    Union(value:CodeUnionDeclaration);
    Newtype(value:CodeNewtypeDeclaration);
    Struct(value:CodeStructDeclaration);
    Enum(value:CodeEnumDeclaration);
}
