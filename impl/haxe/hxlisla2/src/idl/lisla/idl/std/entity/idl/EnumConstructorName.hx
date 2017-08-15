package lisla.idl.std.entity.idl;
import lisla.data.meta.core.StringWithMetadata;
import hxext.ds.Maybe;
import hxext.ds.Result;
import lisla.data.meta.core.Metadata;
import lisla.idl.lisla2entity.error.LislaToEntityErrorKind;
using lisla.string.IdentifierTools;
using StringTools;

class EnumConstructorName
{
	public var kind(default, null):EnumConstructorKind;
	public var name(default, null):String;
	public var metadata(default, null):Metadata;
	
	public function new (name:String, metadata:Metadata)
	{   
		if (name.endsWith(":"))
		{
			name = name.substr(0, name.length - 1);
			kind = EnumConstructorKind.Tuple;
		}
		else if (name.endsWith("<"))
		{
			name = name.substr(0, name.length - 1);
			kind = EnumConstructorKind.Inline;
		}
        else
        {
            kind = EnumConstructorKind.Normal;
        }
		if (!name.isSnakeCase())
		{
			throw "enum constructor name must be snake case name";
		}
        
        this.metadata = metadata;
        this.name = name;
	}
	
	@:lislaToEntity
	public static function lislaToEntity(string:StringWithMetadata):Result<EnumConstructorName, LislaToEntityErrorKind>
	{
		return switch (create(string.data, string.metadata))
		{
			case Result.Ok(data):
				Result.Ok(data);
			
			case Result.Error(data):
				Result.Error(LislaToEntityErrorKind.Fatal(data));
		}
	}
	public static function create(string:String, metadata:Metadata):Result<EnumConstructorName, String>
	{
		return try 
		{
			Result.Ok(new EnumConstructorName(string, metadata));
		}
		catch (err:String)
		{
			Result.Error(err);
		}
	}
    
	public function toPascalCase():Result<String, String>
	{
		return IdentifierTools.toPascalCase(this.name);
	}
}
