package sora.idl.std.data.idl;

class GenericTypeReference
{
	private var parameters:Array<TypeReference>;
	private var typePath:TypePath;
	
	public function new(typePath:TypePath, parameters:Array<TypeReference>) 
	{
		this.typePath = typePath;
		this.parameters = parameters;
	}
}
