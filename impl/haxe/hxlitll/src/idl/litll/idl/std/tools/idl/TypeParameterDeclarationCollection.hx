package litll.idl.std.tools.idl;
import litll.idl.std.entity.idl.TypeName;
import litll.idl.std.entity.idl.TypeDependenceDeclaration;

typedef TypeParameterDeclarationCollection =
{
    parameters: Array<TypeName>,
    dependences: Array<TypeDependenceDeclaration>
}
