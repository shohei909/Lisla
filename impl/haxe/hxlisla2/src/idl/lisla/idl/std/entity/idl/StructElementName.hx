package lisla.idl.std.entity.idl;

import lisla.data.meta.core.StringWithMetadata;
import hxext.ds.Maybe;
import hxext.ds.Result;
import lisla.data.meta.core.Metadata;
import lisla.idl.lisla2entity.error.LislaToEntityErrorKind;
using hxext.ds.ResultTools;
using lisla.string.IdentifierTools;
using StringTools;

class StructElementName
{
    public var kind(default, null):StructElementKind;
	public var name(default, null):String;
	public var metadata(default, null):Metadata;
	
    public function new(name:String, metadata:Metadata) 
    {
        if (name.endsWith("?<"))
		{
			name = name.substr(0, name.length - 2);
			kind = StructElementKind.OptionalInline;
		}
		else if (name.endsWith("..<"))
		{
			name = name.substr(0, name.length - 3);
			kind = StructElementKind.ArrayInline;
		}
		else if (name.endsWith(".."))
		{
			name = name.substr(0, name.length - 2);
			kind = StructElementKind.Array;
		}
		else if (name.endsWith("?"))
		{
			name = name.substr(0, name.length - 1);
			kind = StructElementKind.Optional;
		}
		else if (name.endsWith("<<"))
		{
			name = name.substr(0, name.length - 2);
			kind = StructElementKind.Merge;
		}
		else if (name.endsWith("<"))
		{
			name = name.substr(0, name.length - 1);
			kind = StructElementKind.Inline;
		}
		else
		{
			kind = StructElementKind.Normal;
		}
		if (!name.isSnakeCase())
		{
			throw "struct field name must be snake case name";
		}
		
		this.name = name;
        this.metadata = metadata;
    }
    
	@:lislaToEntity
	public static function lislaToEntity(string:StringWithMetadata):Result<StructElementName, LislaToEntityErrorKind>
	{
		return switch (create(string.data, string.metadata))
		{
			case Result.Ok(data):
				Result.Ok(data);
			
			case Result.Error(data):
				Result.Error(LislaToEntityErrorKind.Fatal(data));
		}
	}
	public static function create(string:String, metadata:Metadata):Result<StructElementName, String>
	{
		return try 
		{
			Result.Ok(new StructElementName(string, metadata));
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