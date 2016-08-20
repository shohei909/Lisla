package sora.idl.std.data.idl;

enum TypeDefinition
{
	Struct(name:TypeNameDeclaration, arguments:Array<Argument>);
	Enum(name:TypeNameDeclaration, constructors:Array<EnumConstructor>);
	Alias(name:TypeNameDeclaration, type:TypeReference);
	Union(name:TypeNameDeclaration, elements:Array<UnionElement>);
	Tuple(name:TypeNameDeclaration, arguments:Array<Argument>);
}
