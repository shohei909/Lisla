package arraytree.idl.std.entity.idl;
import arraytree.data.meta.core.StringWithMetadata;
import hxext.ds.Maybe;
import hxext.ds.Result;
import arraytree.string.IdentifierTools;
import arraytree.data.meta.core.Metadata;
import arraytree.idl.arraytree2entity.error.ArrayTreeToEntityErrorKind;
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
	
	@:arraytreeToEntity
	public static function arraytreeToEntity(string:StringWithMetadata):Result<TypeDependenceName, ArrayTreeToEntityErrorKind>
	{
		return try
		{
			Result.Ok(new TypeDependenceName(string));
		}
		catch (err:String)
		{
			Result.Error(ArrayTreeToEntityErrorKind.Fatal(err));
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
