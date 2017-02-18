package litll.idl.std.data.idl;
import litll.core.LitllString;
import hxext.ds.Maybe;
import litll.core.tag.StringTag;
import litll.idl.litll2entity.error.LitllToEntityErrorKind;
import litll.idl.std.data.idl.PackagePath;
import hxext.ds.Result;

class ModulePath 
{
	public var packagePath(default, null):PackagePath;
	public var fileName(default, null):String;
	public var tag(default, null):Maybe<StringTag>;
	
	public function new(path:Array<String>, ?tag:Maybe<StringTag>)
	{
		packagePath = new PackagePath(path.slice(0, path.length - 1), tag);
		fileName = path[path.length - 1];
		this.tag = tag;
		PackagePath.validateElement(fileName);
	}
	
	@:litllToEntity
	public static function litllToEntity(string:LitllString):Result<ModulePath, LitllToEntityErrorKind>
	{
		return switch (create(string.data, string.tag))
		{
			case Result.Ok(data):
				Result.Ok(data);
				
			case Result.Err(err):
				Result.Err(LitllToEntityErrorKind.Fatal(err));
		}
	}
	
	public static function create(string:String, ?tag:Maybe<StringTag>):Result<ModulePath, String>
	{
		var array = string.split(".");
		return try 
		{
			Result.Ok(new ModulePath(array, tag));
		}
		catch (err:String)
		{
			Result.Err(err);
		}
	}
	
	public function toString():String
	{
		var directoryString = packagePath.toString();
		return if (directoryString.length == 0) fileName else directoryString + "." + fileName;
	}
	
	public function toArray():Array<String>
	{
		return packagePath.toArray().concat([fileName]);
	}
}
