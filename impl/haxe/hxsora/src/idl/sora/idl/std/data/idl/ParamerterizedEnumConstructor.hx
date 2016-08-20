package sora.idl.std.data.idl;

class ParamerterizedEnumConstructor
{
	public var name(default, null):EnumConstructorName;
	public var arguments(default, null):Array<Argument>;
	
	public function new(name:EnumConstructorName, arguments:Array<Argument>) 
	{
		this.name = name;
		this.arguments = arguments;
	}
}