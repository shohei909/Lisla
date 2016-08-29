package sora.idl.std.data.idl;
import sora.core.ds.Result;

abstract PackagePath(Array<String>)
{
	private static var headEReg:EReg = ~/[a-z]/;
	private static var bodyEReg:EReg = ~/[0-9a-z_]*/;
	
	public function new(directories:Array<String>)
	{
		for (directory in directories)
		{
			validateElement(directory);
		}
		this = directories;
	}
	
	public static function validateElement(string:String):Void
	{
		if (string.length == 0)
		{
			throw "Package name must not be empty.";
		}
		else if (!headEReg.match(string.substr(0, 1)))
		{
			throw "Package name must start with lowercase alphabet.";
		}
		else if (!bodyEReg.match(string.substr(1)))
		{
			throw "Lowercase alphabets, numbers and underscore is only allowed in package name.";
		}
	}
	
	public static function create(string:String):Result<PackagePath, String>
	{
		var array = string.split(".");
		return try 
		{
			Result.Ok(new PackagePath(array));
		}
		catch (err:String)
		{
			Result.Err(err);
		}
	}
	
	public function toString():String
	{
		return this.join(".");
	}
	
	public function toArray():Array<String>
	{
		return this;
	}
}
