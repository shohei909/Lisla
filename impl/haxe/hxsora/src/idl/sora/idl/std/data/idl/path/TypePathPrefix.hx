package sora.idl.std.data.idl.path;
import haxe.ds.Option;
import sora.core.ds.Result;
import sora.idl.std.data.idl.PackagePath;
import sora.idl.std.data.idl.TypeName;

class TypePathPrefix
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
		
		typeName = switch (TypeName.create(typeNameString))
		{
			case Result.Ok(t):
				if (path.length < 2)
				{
					throw "Module name is required";
				}
				packagePath = new PackagePath(path.slice(0, path.length - 1));
				Option.Some(t);
				
			case Result.Err(_):
				packagePath = new PackagePath(path);
				Option.None;
		}
	}
}
