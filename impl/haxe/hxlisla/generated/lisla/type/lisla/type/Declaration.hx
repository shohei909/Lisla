package lisla.type.lisla.type;

enum Declaration 
{
    Import(value:ImportDeclaration);
    Tuple(value:TupleDeclaration);
    Union(value:UnionDeclaration);
    Newtype(value:NewtypeDeclaration);
    Struct(value:StructDeclaration);
    Enum(value:EnumDeclaration);
}