	package sora.idl.std.data.idl;
import sora.core.ds.Result;
import sora.core.string.IdentifierTools;

abstract TypeName(String) 
{
	private static var headEReg:EReg = ~/[A-Z]/;
	private static var bodyEReg:EReg = ~/[0-9a-zA-Z]*/;
	
	public function new (string:String) 
	{
		validate(string);
		this = string;
	}
	
	public static function create(string:String):Result<TypeName, String>
	{
		return try 
		{
			Result.Ok(new TypeName(string));
		}
		catch (err:String)
		{
			Result.Err(err);
		}
	}
	
	public static function validate(string:String):Void
	{
		if (string.length == 0)
		{
			throw "Type name must not be empty.";
		}
		else if (!headEReg.match(string.substr(0, 1)))
		{
			throw "Type name must start with uppercase alphabet.";
		}
		else if (!bodyEReg.match(string.substr(1)))
		{
			throw "Alphabets and numbers is only allowed in type name.";
		}
	}
	
	public function toString():String
	{
		return this;
	}
}
