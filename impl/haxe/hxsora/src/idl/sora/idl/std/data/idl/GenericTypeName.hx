package sora.idl.std.data.idl;

class GenericTypeName
{
	public var name(default, null):TypeName;
	public var parameters(default, null):Array<TypeParameterDeclaration>;
	
	public function new(name:TypeName, parameters:Array<TypeParameterDeclaration>) 
	{
		this.name = name;
		this.parameters = parameters;
	}
}
