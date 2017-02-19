package litll.idl.library;
import haxe.io.Path;
import hxext.ds.OrderedMap;
import hxext.ds.Result;
import litll.idl.litlltext2entity.LitllFileToEntityRunner;
import litll.idl.litlltext2entity.error.LitllFileToEntityError;
import litll.idl.std.data.idl.library.LibraryConfig;
import litll.idl.std.litll2entity.idl.library.LibraryConfigLitllToEntity;
import sys.FileSystem;
import sys.io.File;

class IdlLibraryMap 
{
    public var map(default, null):Map<String, IdlLibrary>;
    
    public function new() 
    {
        map = new Map();
    }
    
    public function read(name:String, file:String, errorOutput:Array<LitllFileToEntityError>):Void
    {
        return switch(LitllFileToEntityRunner.run(LibraryConfigLitllToEntity, file))
        {
            case Result.Ok(config):
                var lib = if (map.exists(name))
                {
                    map.get(name);
                }
                else
                {
                    map[name] = new IdlLibrary();
                }
                
                lib.add(Path.directory(file), name, config);
                
            case Result.Err(errors):
                for (e in errors) errorOutput.push(e);
        }
    }
    
}
