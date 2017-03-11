package lisla.idl.std.entity.idl;
import hxext.ds.Maybe;
import hxext.ds.Result;
import lisla.core.LislaString;
import lisla.core.tag.StringTag;
import lisla.idl.lisla2entity.error.LislaToEntityErrorKind;

class PackagePath
{
	private static var headEReg:EReg = ~/[a-z]/;
	private static var bodyEReg:EReg = ~/[0-9a-z_]*/;
	
	public var path:Array<String>;
	public var tag:Maybe<StringTag>;
	
	public function new(path:Array<String>, ?tag:Maybe<StringTag>)
	{
		this.tag = tag;
		for (segment in path)
		{
			validateElement(segment);
		}
        this.path = path;
	}
	
    public function concat(additional:Array<String>):PackagePath
    {
        return new PackagePath(path.concat(additional), tag);
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
	
	@:lislaToEntity
	public static function lislaToEntity(string:LislaString):Result<PackagePath, LislaToEntityErrorKind>
	{
		return switch (create(string.data, string.tag))
		{
			case Result.Ok(data):
				Result.Ok(data);
				
			case Result.Err(err):
				Result.Err(LislaToEntityErrorKind.Fatal(err));
		}
	}
	
	public static function create(string:String, ?tag:Maybe<StringTag>):Result<PackagePath, String>
	{
		var array = string.split(".");
		return try 
		{
			Result.Ok(new PackagePath(array, tag));
		}
		catch (err:String)
		{
			Result.Err(err);
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
            tag
        );
    }
}