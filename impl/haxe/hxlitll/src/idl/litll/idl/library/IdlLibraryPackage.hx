package litll.idl.library;
import hxext.ds.OrderedMap;
import litll.idl.std.data.idl.library.LibraryConfig;
import litll.idl.std.data.util.version.Version;

class IdlLibraryPackage
{   
    private var config:LibraryConfig;
    private var name:String;
    private var directory:String;
    
    public function new(directory:String, name:String, config:LibraryConfig) 
    {
        this.directory = directory;
        this.name = name;
        this.config = config;
    }
}
