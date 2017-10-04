package arraytree.idl.std.entity.idl;
import hxext.ds.Maybe;
import hxext.ds.Result;
import arraytree.data.meta.core.StringWithMetadata;
import arraytree.data.meta.core.Metadata;
import arraytree.idl.arraytree2entity.error.ArrayTreeToEntityErrorKind;

class PackagePath
{
	private static var headEReg:EReg = ~/[a-z]/;
	private static var bodyEReg:EReg = ~/[0-9a-z_]*/;
	
	public var path:Array<String>;
	public var metadata:Metadata;
	
	public function new(path:Array<String>, metadata:Metadata)
	{
		this.metadata = metadata;
		for (segment in path)
		{
			validateElement(segment);
		}
        this.path = path;
	}
	
    public function concat(additional:Array<String>):PackagePath
    {
        return new PackagePath(path.concat(additional), metadata);
    }
    
	public static function validateElement(string:String):Void
	{
		if (string.length == 0)
		{
			//throw "Package name must not be empty.";
		}
		else if (!headEReg.match(string.substr(0, 1)))
		{
			throw "Package name must start with lowercase alphabet: " + string;
		}
		else if (!bodyEReg.match(string.substr(1)))
		{
			throw "Lowercase alphabets, numbers and underscore is only allowed in package name: " + string;
		}
	}
	
	@:arraytreeToEntity
	public static function arraytreeToEntity(string:StringWithMetadata):Result<PackagePath, ArrayTreeToEntityErrorKind>
	{
		return switch (create(string.data, string.metadata))
		{
			case Result.Ok(data):
				Result.Ok(data);
				
			case Result.Error(err):
				Result.Error(ArrayTreeToEntityErrorKind.Fatal(err));
		}
	}
	
	public static function create(string:String, metadata:Metadata):Result<PackagePath, String>
	{
		var array = string.split(".");
		return try 
		{
			Result.Ok(new PackagePath(array, metadata));
		}
		catch (err:String)
		{
			Result.Error(err);
		}
	}
	
	public function toString():String
	{
		return this.path.join(".");
	}
	
	public function toArray():Array<String>
	{
		return this.path;
	}
    
    public function toModulePath():ModulePath
    {
        return new ModulePath(
            path,
            metadata
        );
    }
}
