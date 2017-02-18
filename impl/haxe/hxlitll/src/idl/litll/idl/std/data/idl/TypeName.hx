package litll.idl.std.data.idl;
import litll.core.LitllString;
import litll.core.ds.Maybe;
import litll.core.ds.Result;
import litll.core.string.IdentifierTools;
import litll.core.tag.StringTag;
import litll.idl.litll2entity.LitllToEntityError;
import litll.idl.litll2entity.LitllToEntityErrorKind;
using litll.core.ds.ResultTools;

@:forward(tag)
abstract TypeName(LitllString)
{
	private static var headEReg:EReg = ~/[A-Z]/;
	private static var bodyEReg:EReg = ~/[0-9a-zA-Z]*/;
	
	public var tag(get, never):Maybe<StringTag>; 
	private function get_tag():Maybe<StringTag>
	{
		return this.tag;
	}
	
	public function new (string:LitllString) 
	{
		validate(string.data);
		this = string;
	}
	
	@:litllToEntity
	public static function litllToEntity(string:LitllString):Result<TypeName, LitllToEntityErrorKind>
	{
		return try
		{
			Result.Ok(new TypeName(string));
		}
		catch (err:String)
		{
			Result.Err(LitllToEntityErrorKind.Fatal(err));
		}
	}
	
	public static function create(string:String, ?tag:Maybe<StringTag>):Result<TypeName, String>
	{
		return try
		{
			Result.Ok(new TypeName(new LitllString(string, tag)));
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
    
    public function toLitllToEntityVariableName():String
    {
        return toVariableName() + "LitllToEntity";
    }
	
	public function map(func:String->String):TypeName
	{
		return new TypeName(new LitllString(func(this.data), this.tag));
	}
}
