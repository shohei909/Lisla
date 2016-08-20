package sora.idl.std.data.idl;
import sora.core.ds.Result;
import sora.core.string.CaseTools;
using StringTools;

class ArgumentName 
{
	public var kind(default, null):ArgumentKind;
	public var name(default, null):String;
	
	public function new (name:String)
	{
		if (name.endsWith(".."))
		{
			name = name.substr(0, name.length - 2);
			kind = Rest;
		}
		else if (name.endsWith("?"))
		{
			name = name.substr(0, name.length - 1);
			kind = Skippable;
		}
		else if (name.endsWith("{}"))
		{
			name = name.substr(0, name.length - 2);
			kind = Structure;
		}
		else
		{
			kind = Normal;
		}
		
		if (name.length == 0)
		{
			throw "must not be empty.";
		}
		
		this.name = name;
	}
	
	public static function create(string:String):Result<ArgumentName, String>
	{
		return try 
		{
			Result.Ok(new ArgumentName(string));
		}
		catch (err:String)
		{
			Result.Err(err);
		}
	}
	
	public function toCamelCase():Result<String, String>
	{
		return CaseTools.toCamelCase(name);
	}
}

enum ArgumentKind
{
	Normal;
	Skippable;
	Structure;
	Rest;
}
