package arraytree.idl.std.entity.idl.group;
import haxe.ds.Option;
import arraytree.data.meta.core.StringWithMetadata;
import hxext.ds.Maybe;
import hxext.ds.Result;
import arraytree.data.meta.core.Metadata;
import arraytree.idl.arraytree2entity.error.ArrayTreeToEntityErrorKind;
import arraytree.idl.std.entity.idl.PackagePath;
import arraytree.idl.std.entity.idl.TypeName;
import arraytree.idl.std.entity.idl.TypePath;

class TypeGroupPath
{
	public var packagePath(default, null):Maybe<PackagePath>;
	public var typeName(default, null):Maybe<TypeName>;
	public var metadata(default, null):Metadata;
	
	public function new (path:Array<String>, metadata:Metadata)
	{
		this.metadata = metadata;
		if (path.length == 0)
		{
			throw "Type group path must not be empty.";
		}
		
		var lastString = path[path.length - 1];	
		if (lastString.length == 0)
		{
			throw "Package name　and type name must not be empty.";
		}
		
		switch (TypeName.create(lastString, metadata))
		{
			case Result.Ok(t):
				packagePath = if (path.length < 2)
				{
					Maybe.none();
				}
				else
				{
					Maybe.some(new PackagePath(path.slice(0, path.length - 1), metadata));
				}
				
				typeName = Maybe.some(t);
				
			case Result.Error(_):
				packagePath = Maybe.some(new PackagePath(path, metadata));
				typeName = Maybe.none();
		}
	}
	
	@:arraytreeToEntity
	public static function arraytreeToEntity(string:StringWithMetadata):Result<TypeGroupPath, ArrayTreeToEntityErrorKind>
	{
		return switch (create(string.data, string.metadata))
		{
			case Result.Ok(data):
				Result.Ok(data);
				
			case Result.Error(err):
				Result.Error(ArrayTreeToEntityErrorKind.Fatal(err));
		}
	}
	
	public static function create(string:String, metadata:Metadata):Result<TypeGroupPath, String>
	{
		var array = string.split(".");
		return try 
		{
			Result.Ok(new TypeGroupPath(array, metadata));
		}
		catch (err:String)
		{
			Result.Error(err);
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
				switch (TypePath.create(dest.toString() + localPath, typePath.metadata))
				{
					case Result.Ok(data):
						Maybe.some(data);
						
					case Result.Error(_):
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
