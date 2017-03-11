package litll.idl.std.entity.idl;
import haxe.ds.Option;
import litll.core.LitllString;
import hxext.ds.Maybe;
import hxext.ds.Result;
import litll.core.tag.StringTag;
import litll.idl.litll2entity.error.LitllToEntityErrorKind;
import litll.idl.std.entity.idl.group.TypeGroupPath;

class TypePath
{
	public var modulePath:Maybe<ModulePath>;
	public var typeName:TypeName;
	public var tag(default, null):Maybe<StringTag>;
    
	public function new(modulePath:Maybe<ModulePath>, typeName:TypeName, ?tag:Maybe<StringTag>)
	{
		this.modulePath = modulePath;
		this.typeName = typeName;
		this.tag = tag;
	}
	
	@:litllToEntity
	public static function litllToEntity(string:LitllString):Result<TypePath, LitllToEntityErrorKind>
	{
		return switch (create(string.data, string.tag))
		{
			case Result.Ok(data):
				Result.Ok(data);
			
			case Result.Err(data):
				Result.Err(LitllToEntityErrorKind.Fatal(data));
		}
	}
	
	public static function create(string:String, ?tag:Maybe<StringTag>):Result<TypePath, String>
	{
		return createFromArray(string.split("."), tag);
	}
	
	public static function createFromArray(array:Array<String>, ?tag:Maybe<StringTag>):Result<TypePath, String>
	{
		if (array.length == 0)
		{
			return Result.Err("Type array must not be empty.");
		}
		return try 
		{
			var modulePath = if (array.length == 1)
			{
				Maybe.none();
			}
			else
			{
				Maybe.some(new ModulePath(array.slice(0, array.length - 1), tag));
			}
			var typeNameString = array[array.length - 1];	
			
			Result.Ok(
				new TypePath(modulePath, new TypeName(new LitllString(typeNameString, tag)), tag)
			);
		}
		catch (err:String)
		{
			Result.Err(err);
		}
	}
	
	public function toString():String
	{
		return modulePath.map(function (_modulePath) return _modulePath.toString() + ".").getOrElse("") + typeName.toString();
	}
	
	public function toArray():Array<String>
	{
		return switch (modulePath.toOption())
		{
			case Option.Some(_modulePath):
				_modulePath.toArray().concat([typeName.toString()]);
				
			case Option.None:
				[typeName.toString()];
		}
	}
	
	public function isCoreType():Bool
	{
		return switch (modulePath.toOption())
		{
			case Option.None if (typeName.toString() == "String" || typeName.toString() == "Array"):
				true;
				
			case _:
				false;
		}
	}
    
    public function isStringType():Bool
    {
    	return switch (modulePath.toOption())
		{
			case Option.None if (typeName.toString() == "String"):
				true;
				
			case _:
				false;
		}
    }
	
	public function getModuleArray():Array<String>
	{
		return switch (modulePath.toOption())
		{
			case Option.Some(_modulePath):
				_modulePath.toArray();
				
			case Option.None:
				[];
		}
	}
}
