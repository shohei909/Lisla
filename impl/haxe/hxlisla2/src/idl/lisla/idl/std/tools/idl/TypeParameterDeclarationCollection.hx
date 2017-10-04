package arraytree.idl.std.tools.idl;
import arraytree.idl.std.entity.idl.TypeName;
import arraytree.idl.std.entity.idl.TypeDependenceDeclaration;

typedef TypeParameterDeclarationCollection =
{
    parameters: Array<TypeName>,
    dependences: Array<TypeDependenceDeclaration>
}
