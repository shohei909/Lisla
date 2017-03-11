package lisla.idl.std.entity.idl.group;
import haxe.ds.Option;
import lisla.core.LislaString;
import hxext.ds.Maybe;
import hxext.ds.Result;
import lisla.core.tag.StringTag;
import lisla.idl.lisla2entity.error.LislaToEntityErrorKind;
import lisla.idl.std.entity.idl.PackagePath;
import lisla.idl.std.entity.idl.TypeName;
import lisla.idl.std.entity.idl.TypePath;

class TypeGroupPath
{
	public var packagePath(default, null):Maybe<PackagePath>;
	public var typeName(default, null):Maybe<TypeName>;
	public var tag(default, null):Maybe<StringTag>;
	
	public function new (path:Array<String>, ?tag:Maybe<StringTag>)
	{
		this.tag = tag;
		if (path.length == 0)
		{
			throw "Type group path must not be empty.";
		}
		
		var lastString = path[path.length - 1];	
		if (lastString.length == 0)
		{
			throw "Package name　and type name must not be empty.";
		}
		
		switch (TypeName.create(lastString, tag))
		{
			case Result.Ok(t):
				packagePath = if (path.length < 2)
				{
					Maybe.none();
				}
				else
				{
					Maybe.some(new PackagePath(path.slice(0, path.length - 1), tag));
				}
				
				typeName = Maybe.some(t);
				
			case Result.Err(_):
				packagePath = Maybe.some(new PackagePath(path, tag));
				typeName = Maybe.none();
		}
	}
	
	@:lislaToEntity
	public static function lislaToEntity(string:LislaString):Result<TypeGroupPath, LislaToEntityErrorKind>
	{
		return switch (create(string.data, string.tag))
		{
			case Result.Ok(data):
				Result.Ok(data);
				
			case Result.Err(err):
				Result.Err(LislaToEntityErrorKind.Fatal(err));
		}
	}
	
	public static function create(string:String, ?tag:Maybe<StringTag>):Result<TypeGroupPath, String>
	{
		var array = string.split(".");
		return try 
		{
			Result.Ok(new TypeGroupPath(array, tag));
		}
		catch (err:String)
		{
			Result.Err(err);
		}
	}
	
	public function filter(typePath:TypePath, dest:TypeGroupPath):Maybe<TypePath>
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
						Maybe.some(data);
						
					case Result.Err(_):
						Maybe.none();
				}
			}
			else
			{
				Maybe.none();
			}
		}
		else
		{
			Maybe.none();
		}
	}
	
	public function toString():String
	{
		var str = switch [packagePath.toOption(), typeName.toOption()]
		{
			case [Option.Some(pack), Option.Some(name)]:
				pack.toString() + "." + name.toString();
				
			case [Option.Some(pack), Option.None]:
				pack.toString();
				
			case [Option.None, Option.Some(name)]:
				name.toString();
				
			case [Option.None, Option.None]:
				"";
		}
		return str;
	}
}
