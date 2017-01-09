package litll.idl.std.tools.idl;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypeDependenceDeclaration;

typedef TypeParameterDeclarationCollection =
{
    parameters: Array<TypeName>,
    dependences: Array<TypeDependenceDeclaration>
}
