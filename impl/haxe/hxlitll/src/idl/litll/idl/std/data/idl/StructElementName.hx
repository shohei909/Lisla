package litll.idl.std.data.idl;

import litll.core.LitllString;
import litll.core.ds.Maybe;
import litll.core.ds.Result;
import litll.core.tag.StringTag;
import litll.idl.delitllfy.DelitllfyErrorKind;
using litll.core.ds.ResultTools;
using litll.core.string.IdentifierTools;
using StringTools;

class StructElementName
{
    public var kind(default, null):StructFieldKind;
	public var name(default, null):String;
	public var tag(default, null):Maybe<StringTag>;
	
    public function new(name:String, ?tag:Maybe<StringTag>) 
    {
        if (name.endsWith("?<"))
		{
			name = name.substr(0, name.length - 2);
			kind = StructFieldKind.OptionalInline;
		}
		else if (name.endsWith("..<"))
		{
			name = name.substr(0, name.length - 3);
			kind = StructFieldKind.ArrayInline;
		}
		if (name.endsWith(".."))
		{
			name = name.substr(0, name.length - 2);
			kind = StructFieldKind.Array;
		}
		else if (name.endsWith("?"))
		{
			name = name.substr(0, name.length - 1);
			kind = StructFieldKind.Optional;
		}
		else if (name.endsWith("<<"))
		{
			name = name.substr(0, name.length - 2);
			kind = StructFieldKind.Merge;
		}
		else if (name.endsWith("<"))
		{
			name = name.substr(0, name.length - 1);
			kind = StructFieldKind.Inline;
		}
		else
		{
			kind = StructFieldKind.Normal;
		}
		if (!name.isSnakeCase())
		{
			throw "struct field name must be snake case name";
		}
		
		this.name = name;
        this.tag = tag;
    }
    
	@:delitllfy
	public static function delitllfy(string:LitllString):Result<StructElementName, DelitllfyErrorKind>
	{
		return switch (create(string.data, string.tag))
		{
			case Result.Ok(data):
				Result.Ok(data);
			
			case Result.Err(data):
				Result.Err(DelitllfyErrorKind.Fatal(data));
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