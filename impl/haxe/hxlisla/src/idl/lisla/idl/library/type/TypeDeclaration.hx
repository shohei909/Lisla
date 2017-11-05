package lisla.idl.library.type;
import lisla.type.lisla.type.EnumDeclaration;
import lisla.type.lisla.type.NewtypeDeclaration;
import lisla.type.lisla.type.StructDeclaration;
import lisla.type.lisla.type.TupleDeclaration;
import lisla.type.lisla.type.UnionDeclaration;

enum TypeDeclaration 
{
    Tuple(value:TupleDeclaration);
    Union(value:UnionDeclaration);
    Newtype(value:NewtypeDeclaration);
    Struct(value:StructDeclaration);
    Enum(value:EnumDeclaration);
}
