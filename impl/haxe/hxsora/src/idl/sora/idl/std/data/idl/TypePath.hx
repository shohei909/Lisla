package sora.idl.std.data.idl;
import haxe.ds.Option;
import sora.core.ds.Result;

class TypePath
{
	public var filePath(default, null):Option<ModulePath>;
	public var typeName(default, null):TypeName;
	
	private function new(path:Array<String>)
	{
		if (path.length == 0)
		{
			throw "Type path must not be empty.";
		}
		else if (path.length == 1)
		{
			filePath = Option.None;
		}
		else
		{
			filePath = Option.Some(new ModulePath(path.slice(0, path.length - 1)));
		}
		
		var typeNameString = path[path.length - 1];	
		typeName = new TypeName(typeNameString);
	}
	
	public static function create(string:String):Result<TypePath, String>
	{
		var array = string.split(".");
		
		return try 
		{
			Result.Ok(new TypePath(array));
		}
		catch (err:String)
		{
			Result.Err(err);
		}
	}
	
	public function toString():String
	{
		return switch (filePath)
		{
			case Option.Some(_filePath):
				_filePath.toString() + "." + typeName.toString();
				
			case Option.None:
				typeName.toString();
		}
	}
}
