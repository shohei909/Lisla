package litll.idl.std.data.idl;
import litll.core.LitllString;
import litll.core.ds.Maybe;
import litll.core.ds.Result;
import litll.core.tag.StringTag;
import litll.idl.litll2entity.LitllToEntityErrorKind;
using litll.core.ds.ResultTools;
using litll.core.string.IdentifierTools;
using StringTools;

class ArgumentName 
{
	public var kind(default, null):ArgumentKind;
	public var name(default, null):String;
	public var tag(default, null):Maybe<StringTag>;
	
	public function new (name:String, ?tag:Maybe<StringTag>)
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
	
	@:litllToEntity
	public static function litllToEntity(string:LitllString):Result<ArgumentName, LitllToEntityErrorKind>
	{
		return switch (create(string.data, string.tag))
		{
			case Result.Ok(data):
				Result.Ok(data);
			
			case Result.Err(data):
				Result.Err(LitllToEntityErrorKind.Fatal(data));
		}
	}
	public static function create(string:String, ?tag:Maybe<StringTag>):Result<ArgumentName, String>
	{
		return try 
		{
			Result.Ok(new ArgumentName(string, tag));
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

