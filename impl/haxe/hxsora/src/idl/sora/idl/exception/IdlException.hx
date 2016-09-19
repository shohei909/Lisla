package sora.idl.exception;

class IdlException
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