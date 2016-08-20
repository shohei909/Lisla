package sora.haxe.data;

class HaxeTypeReference
{
	public var name(default, null):HaxeTypePath;
	public var parameters(default, null):Array<HaxeTypeReference>;
	
	public function new(name:HaxeTypePath, parameters:Array<HaxeTypeReference>) 
	{
		this.name = name;
		this.parameters = parameters;
	}
}
