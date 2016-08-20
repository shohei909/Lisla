package sora.haxe.data;

class HaxeClassDefinition
{
	public var functions:Array<HaxeFunctionDefinition>;
	public var variables:Array<HaxeVariableDefinition>;
	
	public function new (variables:Array<HaxeVariableDefinition>, functions:Array<HaxeFunctionDefinition>):Void
	{
		this.variables = variables;
		this.functions = functions;
	}
}
