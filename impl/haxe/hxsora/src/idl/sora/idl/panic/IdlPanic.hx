package sora.idl.panic;

class IdlPanic
{
	public var message(default, null):String;
	public function new(message:String) 
	{
		this.message = message;
	}	
	
	public function toString():String
	{
		return Type.getClassName(Type.getClass(this)) + ": " + message;
	}
}