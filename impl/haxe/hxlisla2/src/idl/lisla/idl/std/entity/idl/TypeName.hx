package lisla.idl.std.entity.idl;
import lisla.data.meta.core.Metadata;
import lisla.data.meta.core.StringWithMetadata;
import hxext.ds.Maybe;
import hxext.ds.Result;
import lisla.string.IdentifierTools;
import lisla.data.meta.core.Metadata;
import lisla.idl.lisla2entity.error.LislaToEntityError;
import lisla.idl.lisla2entity.error.LislaToEntityErrorKind;
using hxext.ds.ResultTools;

@:forward(metadata)
abstract TypeName(StringWithMetadata)
{
	private static var headEReg:EReg = ~/[A-Z]/;
	private static var bodyEReg:EReg = ~/[0-9a-zA-Z]*/;
	
	public function new (string:StringWithMetadata) 
	{
		validate(string.data);
		this = string;
	}
	
	@:lislaToEntity
	public static function lislaToEntity(string:StringWithMetadata):Result<TypeName, LislaToEntityErrorKind>
	{
		return try
		{
			Result.Ok(new TypeName(string));
		}
		catch (err:String)
		{
			Result.Error(LislaToEntityErrorKind.Fatal(err));
		}
	}
	
	public static function create(string:String, metadata:Metadata):Result<TypeName, String>
	{
		return try
		{
			Result.Ok(new TypeName(new StringWithMetadata(string, metadata)));
		}
		catch (err:String)
		{
			Result.Error(err);
		}
	}
	public static function validate(string:String):Void
	{
		if (string.length == 0)
		{
			throw "Type name must not be empty.";
		}
		else if (!headEReg.match(string.substr(0, 1)))
		{
			throw "Type name must start with uppercase alphabet.";
		}
		else if (!bodyEReg.match(string.substr(1)))
		{
			throw "Alphabets and numbers is only allowed in type name.";
		}
	}
	
	public function toString():String
	{
		return this.data;
	}
	
	public function toVariableName():String
	{
		return IdentifierTools.toCamelCase(this.data).getOrThrow();
	}
    
    public function toLislaToEntityVariableName():String
    {
        return toVariableName() + "LislaToEntity";
    }
	
	public function map(func:String->String):TypeName
	{
		return new TypeName(new StringWithMetadata(func(this.data), this.metadata));
	}
}
