package lisla.idl.std.tools.idl;
import lisla.idl.std.entity.idl.TypeName;
import lisla.idl.std.entity.idl.TypeDependenceDeclaration;

typedef TypeParameterDeclarationCollection =
{
    parameters: Array<TypeName>,
    dependences: Array<TypeDependenceDeclaration>
}
