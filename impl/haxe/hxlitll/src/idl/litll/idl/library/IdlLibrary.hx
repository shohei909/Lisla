package litll.idl.library;
import hxext.ds.OrderedMap;
import litll.idl.library.IdlLibraryPackage;
import litll.idl.std.data.idl.library.LibraryConfig;

class IdlLibrary
{
    public var versions(default, null):OrderedMap<String, IdlLibraryPackage>;
    
    public function new() 
    {
        versions = new OrderedMap();
    }
    
    public function add(directory:String, name:String, config:LibraryConfig):Void
    {
        var pack = new IdlLibraryPackage(directory, name, config);
        versions.set(config.version.data, pack);
    }
}
