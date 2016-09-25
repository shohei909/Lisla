package litll.idl.std.data.idl;
import litll.core.ds.Result;
import litll.core.string.IdentifierTools;
using litll.core.ds.ResultTools;

abstract TypeDependenceName(String)
{
	public function new (string:String) 
	{
		if (!IdentifierTools.isSnakeCase(string))
		{
			throw "type dependence name must be snake case name";
		}
		this = string;
	}
	
	public static function create(string:String):Result<TypeDependenceName, String>
	{
		return try 
		{
			Result.Ok(new TypeDependenceName(string));
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
}
