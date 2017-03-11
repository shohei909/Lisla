package litll.idl.std.data.idl;
import hxext.ds.Maybe;
import litll.core.tag.StringTag;

class LocalPackagePath 
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
	
    public function concat(strings:Array<String>, ?childTag:Maybe<StringTag>):PackagePath
    {
        return new PackagePath(path.concat(strings), childTag);
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
	
	public function toString():String
	{
		return this.path.join(".");
	}
	
	public function toArray():Array<String>
	{
		return this.path;
	}
    
    
}