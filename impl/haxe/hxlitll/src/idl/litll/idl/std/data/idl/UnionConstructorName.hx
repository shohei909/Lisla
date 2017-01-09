package litll.idl.std.data.idl;
import litll.core.LitllString;
import litll.core.ds.Result;
import litll.idl.delitllfy.DelitllfyErrorKind;
using litll.core.string.IdentifierTools;
using litll.core.ds.ResultTools;

abstract UnionConstructorName(LitllString) 
{
	public function new (string:LitllString) 
	{
		if (!IdentifierTools.isSnakeCase(string.data))
		{
			throw "UnionConstructorName must be snake case";
		}
		this = string;
	}
	
	@:delitllfy
	public static function delitllfy(string:LitllString):Result<UnionConstructorName, DelitllfyErrorKind>
	{
		return try 
		{
			Result.Ok(new UnionConstructorName(string));
		}
		catch (err:String)
		{
			Result.Err(DelitllfyErrorKind.Fatal(err));
		}
	}
	
	public function toString():String
	{
		return this.data;
	}

	public function toPascalCase():String
	{
		return IdentifierTools.toPascalCase(this.data).getOrThrow();
	}
	
	public function toVariableName():String
	{
		return this.data.toCamelCase().getOrThrow().escapeKeyword();
	}
}
