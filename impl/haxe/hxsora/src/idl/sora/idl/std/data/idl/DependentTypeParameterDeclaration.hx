package sora.idl.std.data.idl;

class DependentTypeParameterDeclaration
{
	public var name:TypeName;
	public var type:TypeReference;

	public function new(name:TypeName, type:TypeReference) 
	{
		this.name = name;
		this.type = type;
	}
	
}