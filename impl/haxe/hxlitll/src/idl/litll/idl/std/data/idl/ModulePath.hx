package litll.idl.std.data.idl;
import litll.idl.std.data.idl.PackagePath;
import litll.core.ds.Result;

class ModulePath 
{
	public var packagePath(default, null):PackagePath;
	public var fileName(default, null):String;
	
	public function new(path:Array<String>)
	{
		packagePath = new PackagePath(path.slice(0, path.length - 1));
		fileName = path[path.length - 1];
		PackagePath.validateElement(fileName);
	}
	
	public static function create(string:String):Result<ModulePath, String>
	{
		var array = string.split(".");
		return try 
		{
			Result.Ok(new ModulePath(array));
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
