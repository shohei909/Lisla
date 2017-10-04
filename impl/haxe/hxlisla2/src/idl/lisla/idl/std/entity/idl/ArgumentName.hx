package arraytree.idl.std.entity.idl;
import arraytree.data.meta.core.StringWithMetadata;
import hxext.ds.Maybe;
import hxext.ds.Result;
import arraytree.data.meta.core.Metadata;
import arraytree.idl.arraytree2entity.error.ArrayTreeToEntityErrorKind;
using hxext.ds.ResultTools;
using arraytree.string.IdentifierTools;
using StringTools;

class ArgumentName 
{
	public var kind(default, null):ArgumentKind;
	public var name(default, null):String;
	public var metadata(default, null):Metadata;
	
	public function new (name:String, metadata:Metadata)
	{
        if (name.endsWith("..<"))
		{
			name = name.substr(0, name.length - 3);
			kind = ArgumentKind.RestInline;
		}
		else if (name.endsWith("?<"))
		{
			name = name.substr(0, name.length - 2);
			kind = ArgumentKind.OptionalInline;
		}
		else if (name.endsWith(".."))
		{
			name = name.substr(0, name.length - 2);
			kind = ArgumentKind.Rest;
		}
		else if (name.endsWith("?"))
		{
			name = name.substr(0, name.length - 1);
			kind = ArgumentKind.Optional;
		}
		else if (name.endsWith("<"))
		{
			name = name.substr(0, name.length - 1);
			kind = ArgumentKind.Inline;
		}
		else
		{
			kind = ArgumentKind.Normal;
		}
		if (!name.isSnakeCase())
		{
			throw "argument name must be snake case name";
		}
		
		this.name = name;
	}
	
	@:arraytreeToEntity
	public static function arraytreeToEntity(string:StringWithMetadata):Result<ArgumentName, ArrayTreeToEntityErrorKind>
	{
		return switch (create(string.data, string.metadata))
		{
			case Result.Ok(data):
				Result.Ok(data);
			
			case Result.Error(data):
				Result.Error(ArrayTreeToEntityErrorKind.Fatal(data));
		}
	}
	public static function create(string:String, metadata:Metadata):Result<ArgumentName, String>
	{
		return try 
		{
			Result.Ok(new ArgumentName(string, metadata));
		}
		catch (err:String)
		{
			Result.Error(err);
		}
	}
	
	public function toVariableName():Result<String, String>
	{
		return name.toCamelCase().map(IdentifierTools.escapeKeyword);
	}
}

