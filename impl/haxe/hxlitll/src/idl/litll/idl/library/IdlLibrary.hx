package litll.idl.library;
import hxext.ds.OrderedMap;
import litll.idl.std.data.util.version.Version;

class IdlLibrary
{
    public var packages:OrderedMap<Version, IdlLibraryPackage>;
    
    public function new() 
    {
        
    }
}
