package litll.idl.std.entity.idl;
import hxext.ds.Maybe;
import hxext.ds.Result;
import litll.core.LitllString;
import litll.core.tag.StringTag;
import litll.idl.litll2entity.error.LitllToEntityErrorKind;
import litll.idl.std.entity.idl.LibraryName;

class ModulePath extends LocalModulePath
{
    public var fileName(get, never):String;
    private function get_fileName():String
    {
        return path[path.length - 1];
    }
    
    public var libraryName(get, never):LibraryName;
    private function get_libraryName():LibraryName 
    {
        return new LibraryName(new LitllString(path[0], tag));
    }
    
	public var packagePath(get, never):PackagePath;
    private function get_packagePath():PackagePath {
        return new PackagePath(path.slice(0, path.length - 1), tag);
    }
    
    public function new(path:Array<String>, ?tag:Maybe<StringTag>)
    {
        super(path, tag);
        
        if (path.length == 0)
        {
            throw "Library name required " ;
        }
    }
    
    public function getChild():LocalModulePath
    {
        return new LocalModulePath(
            this.path,
            this.tag
        );
    }
    
	@:litllToEntity
	public static function litllToEntity(string:LitllString):Result<ModulePath, LitllToEntityErrorKind>
	{
		return switch (create(string.data, string.tag))
		{
			case Result.Ok(data):
				Result.Ok(data);
				
			case Result.Err(err):
				Result.Err(LitllToEntityErrorKind.Fatal(err));
		}
	}
	
	public static function create(string:String, ?tag:Maybe<StringTag>):Result<ModulePath, String>
	{
		var array = string.split(".");
		return try 
		{
			Result.Ok(new ModulePath(array, tag));
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
