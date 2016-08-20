package sora.idl.std.data.idl;

class UnionElement
{
	public var name:UnionElementName;
	public var type:TypeReference;
	
	public function new(name:UnionElementName, type:TypeReference) 
	{
		this.name = name;
		this.type = type;
	}
}
