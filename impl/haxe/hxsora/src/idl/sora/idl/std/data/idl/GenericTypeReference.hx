package sora.idl.std.data.idl;

class GenericTypeReference
{
	public var parameters:Array<TypeReference>;
	public var typePath:TypePath;
	
	public function new(typePath:TypePath, parameters:Array<TypeReference>) 
	{
		this.typePath = typePath;
		this.parameters = parameters;
	}
}
