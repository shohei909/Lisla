package sora.haxe.data;

class HaxeNameTypePair
{
	public var name:HaxeIdentifier;
	public var type:HaxeTypeReference;
	
	public function new(name:HaxeIdentifier, type:HaxeTypeReference) 
	{
		this.name = name;
		this.type = type;
	}	
}