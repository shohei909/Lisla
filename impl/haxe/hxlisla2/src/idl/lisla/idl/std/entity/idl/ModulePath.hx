package arraytree.idl.std.entity.idl;
import hxext.ds.Maybe;
import hxext.ds.Result;
import arraytree.data.meta.core.StringWithMetadata;
import arraytree.data.meta.core.Metadata;
import arraytree.idl.arraytree2entity.error.ArrayTreeToEntityErrorKind;
import arraytree.idl.std.entity.idl.LibraryName;

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
        return new LibraryName(new StringWithMetadata(path[0], metadata));
    }
    
	public var packagePath(get, never):PackagePath;
    private function get_packagePath():PackagePath {
        return new PackagePath(path.slice(0, path.length - 1), metadata);
    }
    
    public function new(path:Array<String>, metadata:Metadata)
    {
        super(path, metadata);
        
        if (path.length == 0)
        {
            throw "Library name required " ;
        }
    }
    
    public function getChild():LocalModulePath
    {
        return new LocalModulePath(
            this.path,
            this.metadata
        );
    }
    
	@:arraytreeToEntity
	public static function arraytreeToEntity(string:StringWithMetadata):Result<ModulePath, ArrayTreeToEntityErrorKind>
	{
		return switch (create(string.data, string.metadata))
		{
			case Result.Ok(data):
				Result.Ok(data);
				
			case Result.Error(err):
				Result.Error(ArrayTreeToEntityErrorKind.Fatal(err));
		}
	}
	
	public static function create(string:String, metadata:Metadata):Result<ModulePath, String>
	{
		var array = string.split(".");
		return try 
		{
			Result.Ok(new ModulePath(array, metadata));
		}
		catch (err:String)
		{
			Result.Error(err);
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
