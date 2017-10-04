package arraytree.idl.std.entity.idl;
import arraytree.data.meta.core.Metadata;
import arraytree.data.meta.core.StringWithMetadata;
import hxext.ds.Maybe;
import hxext.ds.Result;
import arraytree.string.IdentifierTools;
import arraytree.data.meta.core.Metadata;
import arraytree.idl.arraytree2entity.error.ArrayTreeToEntityError;
import arraytree.idl.arraytree2entity.error.ArrayTreeToEntityErrorKind;
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
	
	@:arraytreeToEntity
	public static function arraytreeToEntity(string:StringWithMetadata):Result<TypeName, ArrayTreeToEntityErrorKind>
	{
		return try
		{
			Result.Ok(new TypeName(string));
		}
		catch (err:String)
		{
			Result.Error(ArrayTreeToEntityErrorKind.Fatal(err));
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
    
    public function toArrayTreeToEntityVariableName():String
    {
        return toVariableName() + "ArrayTreeToEntity";
    }
	
	public function map(func:String->String):TypeName
	{
		return new TypeName(new StringWithMetadata(func(this.data), this.metadata));
	}
}
