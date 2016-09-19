package sora.idl.std.data.idl.path;
import haxe.ds.Option;
import sora.core.ds.Result;
import sora.idl.std.data.idl.PackagePath;
import sora.idl.std.data.idl.TypeName;
import sora.idl.std.data.idl.TypePath;

class TypeGroupPath
{
	public var packagePath(default, null):PackagePath;
	public var typeName(default, null):Option<TypeName>;
	
	public function new (path:Array<String>)
	{
		if (path.length == 0)
		{
			throw "Type group path must not be empty.";
		}
		
		var lastString = path[path.length - 1];	
		if (lastString.length == 0)
		{
			throw "Package name　and type name must not be empty.";
		}
		
		switch (TypeName.create(lastString))
		{
			case Result.Ok(t):
				if (path.length < 2)
				{
					throw "Module name is required";
				}
				packagePath = new PackagePath(path.slice(0, path.length - 1));
				typeName = Option.Some(t);
				
			case Result.Err(_):
				packagePath = new PackagePath(path);
				typeName = Option.None;
		}
	}
	
	public static function create(string:String):Result<TypeGroupPath, String>
	{
		var array = string.split(".");
		return try 
		{
			Result.Ok(new TypeGroupPath(array));
		}
		catch (err:String)
		{
			Result.Err(err);
		}
	}
	
	public function filter(typePath:TypePath, dest:TypeGroupPath):Option<TypePath>
	{
		var typePathString = typePath.toString();
		var groupString = toString();
		return if (StringTools.startsWith(typePathString, groupString))
		{
			var localPath = typePathString.substr(groupString.length);
			if (localPath == "" || StringTools.startsWith(localPath, "."))
			{
				switch (TypePath.create(dest.toString() + localPath))
				{
					case Result.Ok(data):
						Option.Some(data);
						
					case Result.Err(_):
						Option.None;
				}
			}
			else
			{
				Option.None;
			}
		}
		else
		{
			Option.None;
		}
	}
	public function toString():String
	{
		return packagePath.toString() + switch (typeName)
		{
			case Option.Some(name):
				"." + name.toString();
				
			case Option.None:
				"";
		}
	}
}
