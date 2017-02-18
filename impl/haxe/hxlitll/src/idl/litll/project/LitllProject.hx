package litll.project;
import hxext.ds.OrderedMap;
import litll.idl.ds.ProcessResult;
import litll.idl.generator.data.ProjectConfig;
import litll.idl.library.IdlLibrary;
import litll.idl.std.data.idl.library.LibraryConfig;

class LitllProject 
{
    public var home:String;
    public var library:OrderedMap<String, IdlLibrary>;
    
    public function new() 
    {
        home = "%LITLL_HOME%";
        library = new OrderedMap();
    }
    
    public function apply(config):Void
    {
        
    }
    
    public function generateHaxe(hxinputFilePath:String):ProcessResult
    {
        return ProcessResult.Failure;
    }
}
