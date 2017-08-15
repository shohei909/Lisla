package lisla.idl.std.entity.idl;
import lisla.data.meta.core.StringWithMetadata;
import hxext.ds.Maybe;
import hxext.ds.Result;
import lisla.string.IdentifierTools;
import lisla.data.meta.core.Metadata;
import lisla.idl.lisla2entity.error.LislaToEntityErrorKind;
using hxext.ds.ResultTools;

@:forward(metadata, data)
abstract TypeDependenceName(StringWithMetadata)
{
	public function new (string:StringWithMetadata) 
	{
		if (!IdentifierTools.isSnakeCase(string.data))
		{
			throw "type dependence name must be snake case name";
		}
		this = string;
	}
	
	@:lislaToEntity
	public static function lislaToEntity(string:StringWithMetadata):Result<TypeDependenceName, LislaToEntityErrorKind>
	{
		return try
		{
			Result.Ok(new TypeDependenceName(string));
		}
		catch (err:String)
		{
			Result.Error(LislaToEntityErrorKind.Fatal(err));
		}
	}
	
	public static function create(string:String, metadata:Metadata):Result<TypeDependenceName, String>
	{
		return try 
		{
			Result.Ok(new TypeDependenceName(new StringWithMetadata(string, metadata)));
		}
		catch (err:String)
		{
			Result.Error(err);
		}
	}
	
	public function toVariableName():String
	{
		return "dependence" + IdentifierTools.toPascalCase(this.data).getOrThrow();
	}
}
