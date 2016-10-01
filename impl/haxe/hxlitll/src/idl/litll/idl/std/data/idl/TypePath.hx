package litll.idl.std.data.idl;
import haxe.ds.Option;
import litll.core.ds.Result;
import litll.idl.std.data.idl.path.TypeGroupPath;

class TypePath
{
	public var modulePath:Option<ModulePath>;
	public var typeName:TypeName;

	public function new(modulePath:Option<ModulePath>, typeName:TypeName)
	{
		this.modulePath = modulePath;
		this.typeName = typeName;
	}
	
	public static function create(string:String):Result<TypePath, String>
	{
		return createFromArray(string.split("."));
	}
	
	public static function createFromArray(array:Array<String>):Result<TypePath, String>
	{
		if (array.length == 0)
		{
			return Result.Err("Type array must not be empty.");
		}
		return try 
		{
			var modulePath = if (array.length == 1)
			{
				Option.None;
			}
			else
			{
				Option.Some(new ModulePath(array.slice(0, array.length - 1)));
			}
			var typeNameString = array[array.length - 1];	
			
			Result.Ok(
				new TypePath(modulePath, new TypeName(typeNameString))
			);
		}
		catch (err:String)
		{
			Result.Err(err);
		}
	}
	
	public function toString():String
	{
		return switch (modulePath)
		{
			case Option.Some(_modulePath):
				_modulePath.toString() + "." + typeName.toString();
				
			case Option.None:
				typeName.toString();
		}
	}
	
	public function toArray():Array<String>
	{
		return switch (modulePath)
		{
			case Option.Some(_modulePath):
				_modulePath.toArray().concat([typeName.toString()]);
				
			case Option.None:
				[typeName.toString()];
		}
	}
	
	public function isCoreType():Bool
	{
		return switch (modulePath)
		{
			case Option.None if (typeName.toString() == "String" || typeName.toString() == "Array"):
				true;
				
			case _:
				false;
		}
	}
	
	public function getModuleArray():Array<String>
	{
		return switch (modulePath)
		{
			case Option.Some(_modulePath):
				_modulePath.toArray();
				
			case Option.None:
				[];
		}
	}
}
