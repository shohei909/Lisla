package litll.idl.std.data.idl;
import litll.core.LitllString;
import litll.core.ds.Maybe;
import litll.core.ds.Result;
import litll.core.string.IdentifierTools;
import litll.core.tag.StringTag;
import litll.idl.litll2backend.LitllToBackendErrorKind;
using litll.core.ds.ResultTools;

@:forward(tag, data)
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
	
	@:litllToBackend
	public static function litllToBackend(string:LitllString):Result<TypeDependenceName, LitllToBackendErrorKind>
	{
		return try
		{
			Result.Ok(new TypeDependenceName(string));
		}
		catch (err:String)
		{
			Result.Err(LitllToBackendErrorKind.Fatal(err));
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
	
	public function toVariableName():String
	{
		return "dependence" + IdentifierTools.toPascalCase(this.data).getOrThrow();
	}
}
