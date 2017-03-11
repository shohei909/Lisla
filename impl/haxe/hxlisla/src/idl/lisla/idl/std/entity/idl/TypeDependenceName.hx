package lisla.idl.std.entity.idl;
import lisla.core.LislaString;
import hxext.ds.Maybe;
import hxext.ds.Result;
import lisla.core.string.IdentifierTools;
import lisla.core.tag.StringTag;
import lisla.idl.lisla2entity.error.LislaToEntityErrorKind;
using hxext.ds.ResultTools;

@:forward(tag, data)
abstract TypeDependenceName(LislaString)
{
	public function new (string:LislaString) 
	{
		if (!IdentifierTools.isSnakeCase(string.data))
		{
			throw "type dependence name must be snake case name";
		}
		this = string;
	}
	
	@:lislaToEntity
	public static function lislaToEntity(string:LislaString):Result<TypeDependenceName, LislaToEntityErrorKind>
	{
		return try
		{
			Result.Ok(new TypeDependenceName(string));
		}
		catch (err:String)
		{
			Result.Err(LislaToEntityErrorKind.Fatal(err));
		}
	}
	
	public static function create(string:String, ?tag:Maybe<StringTag>):Result<TypeDependenceName, String>
	{
		return try 
		{
			Result.Ok(new TypeDependenceName(new LislaString(string, tag)));
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
