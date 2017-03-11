package lisla.idl.std.entity.idl;

import lisla.core.LislaString;
import hxext.ds.Maybe;
import hxext.ds.Result;
import lisla.core.tag.StringTag;
import lisla.idl.lisla2entity.error.LislaToEntityErrorKind;
using hxext.ds.ResultTools;
using lisla.core.string.IdentifierTools;
using StringTools;

class StructElementName
{
    public var kind(default, null):StructElementKind;
	public var name(default, null):String;
	public var tag(default, null):Maybe<StringTag>;
	
    public function new(name:String, ?tag:Maybe<StringTag>) 
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
        this.tag = tag;
    }
    
	@:lislaToEntity
	public static function lislaToEntity(string:LislaString):Result<StructElementName, LislaToEntityErrorKind>
	{
		return switch (create(string.data, string.tag))
		{
			case Result.Ok(data):
				Result.Ok(data);
			
			case Result.Err(data):
				Result.Err(LislaToEntityErrorKind.Fatal(data));
		}
	}
	public static function create(string:String, ?tag:Maybe<StringTag>):Result<StructElementName, String>
	{
		return try 
		{
			Result.Ok(new StructElementName(string, tag));
		}
		catch (err:String)
		{
			Result.Err(err);
		}
	}
	public function toVariableName():Result<String, String>
	{
		return name.toCamelCase().map(IdentifierTools.escapeKeyword);
	}
}
