package litll.idl.std.data.idl;
import litll.core.LitllString;
import litll.core.ds.Maybe;
import litll.core.ds.Result;
import litll.core.tag.StringTag;
import litll.idl.delitllfy.DelitllfyErrorKind;
using litll.core.string.IdentifierTools;
using StringTools;

class EnumConstructorName
{
	public var kind(default, null):EnumConstructorKind;
	public var name(default, null):String;
	public var tag(default, null):Maybe<StringTag>;
	
	public function new (name:String, ?tag:Maybe<StringTag>)
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
        
        this.tag = tag;
        this.name = name;
	}
	
	@:delitllfy
	public static function delitllfy(string:LitllString):Result<EnumConstructorName, DelitllfyErrorKind>
	{
		return switch (create(string.data, string.tag))
		{
			case Result.Ok(data):
				Result.Ok(data);
			
			case Result.Err(data):
				Result.Err(DelitllfyErrorKind.Fatal(data));
		}
	}
	public static function create(string:String, ?tag:Maybe<StringTag>):Result<EnumConstructorName, String>
	{
		return try 
		{
			Result.Ok(new EnumConstructorName(string, tag));
		}
		catch (err:String)
		{
			Result.Err(err);
		}
	}
    
	public function toPascalCase():Result<String, String>
	{
		return IdentifierTools.toPascalCase(this.name);
	}
}
