package litll.idl.std.data.idl;
import litll.core.LitllString;
import litll.core.ds.Maybe;
import litll.core.ds.Result;
import litll.core.string.IdentifierTools;
import litll.core.tag.StringTag;
import litll.idl.delitllfy.DelitllfyErrorKind;
using litll.core.ds.ResultTools;

@:forward(tag)
abstract TypeDependenceName(LitllString)
{
	public function new (string:LitllString) 
	{
		if (!IdentifierTools.isSnakeCase(string.data))
		{
			throw "type dependence name must be snake case name";
		}
		this = string;
	}
	
	@:delitllfy
	public static function delitllfy(string:LitllString):Result<TypeDependenceName, DelitllfyErrorKind>
	{
		return try
		{
			Result.Ok(new TypeDependenceName(string));
		}
		catch (err:String)
		{
			Result.Err(DelitllfyErrorKind.Fatal(err));
		}
	}
	
	public static function create(string:String, ?tag:Maybe<StringTag>):Result<TypeDependenceName, String>
	{
		return try 
		{
			Result.Ok(new TypeDependenceName(new LitllString(string, tag)));
		}
		catch (err:String)
		{
			Result.Err(err);
		}
	}
	
	public function toString():String
	{
		return this.data;
	}
    
	public function toVariableName():String
	{
		return "dependance" + IdentifierTools.toPascalCase(this.data).getOrThrow();
	}
}