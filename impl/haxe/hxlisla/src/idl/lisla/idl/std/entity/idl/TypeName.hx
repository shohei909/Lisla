package lisla.idl.std.entity.idl;
import lisla.core.LislaString;
import hxext.ds.Maybe;
import hxext.ds.Result;
import lisla.core.string.IdentifierTools;
import lisla.core.tag.StringTag;
import lisla.idl.lisla2entity.error.LislaToEntityError;
import lisla.idl.lisla2entity.error.LislaToEntityErrorKind;
using hxext.ds.ResultTools;

@:forward(tag)
abstract TypeName(LislaString)
{
	private static var headEReg:EReg = ~/[A-Z]/;
	private static var bodyEReg:EReg = ~/[0-9a-zA-Z]*/;
	
	public var tag(get, never):Maybe<StringTag>; 
	private function get_tag():Maybe<StringTag>
	{
		return this.tag;
	}
	
	public function new (string:LislaString) 
	{
		validate(string.data);
		this = string;
	}
	
	@:lislaToEntity
	public static function lislaToEntity(string:LislaString):Result<TypeName, LislaToEntityErrorKind>
	{
		return try
		{
			Result.Ok(new TypeName(string));
		}
		catch (err:String)
		{
			Result.Err(LislaToEntityErrorKind.Fatal(err));
		}
	}
	
	public static function create(string:String, ?tag:Maybe<StringTag>):Result<TypeName, String>
	{
		return try
		{
			Result.Ok(new TypeName(new LislaString(string, tag)));
		}
		catch (err:String)
		{
			Result.Err(err);
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
		return new TypeName(new LislaString(func(this.data), this.tag));
	}
}
