package sora.idl.std.data.idl;

enum TypeParameterDeclaration
{
	TypeName(typeName:TypeName);
	Dependent(dependent:DependentTypeParameterDeclaration);
}
