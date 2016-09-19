package sora.idl.std.data.idl;
import sora.core.ds.Result;
using sora.core.ds.ResultTools;
using sora.core.string.IdentifierTools;
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
		if (!name.isSnakeCase())
		{
			throw "argument name must be snake case name";
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
	
	public function toVariableName():Result<String, String>
	{
		return name.toCamelCase().map(IdentifierTools.escapeKeyword);
	}
}

enum ArgumentKind
{
	Normal;
	Skippable;
	Structure;
	Rest;
}
