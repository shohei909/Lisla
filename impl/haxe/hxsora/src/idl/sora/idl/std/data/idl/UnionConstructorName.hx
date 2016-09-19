package sora.idl.std.data.idl;
import sora.core.ds.Result;
using sora.core.string.IdentifierTools;
using sora.core.ds.ResultTools;

abstract UnionConstructorName(String) 
{
	public function new (string:String) 
	{
		if (!IdentifierTools.isSnakeCase(string))
		{
			throw "UnionConstructorName must be snake case";
		}
		this = string;
	}
	
	public static function create(string:String):Result<UnionConstructorName, String>
	{
		return try 
		{
			Result.Ok(new UnionConstructorName(string));
		}
		catch (err:String)
		{
			Result.Err(err);
		}
	}
	
	public function toString():String
	{
		return this;
	}

	public function toPascalCase():String
	{
		return IdentifierTools.toPascalCase(this).getOrThrow();
	}
	
	public function toVariableName():String
	{
		return this.toCamelCase().getOrThrow().escapeKeyword();
	}
}
