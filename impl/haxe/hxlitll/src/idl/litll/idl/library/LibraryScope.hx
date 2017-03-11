package litll.idl.library;
import haxe.io.Path;
import hxext.ds.Result;
import litll.core.LitllString;
import litll.idl.generator.error.ReadIdlError;
import litll.idl.generator.error.ReadIdlErrorKind;
import litll.idl.generator.source.IdlFileSourceReader;
import litll.idl.generator.source.validate.ValidType;
import litll.idl.litlltext2entity.LitllFileToEntityRunner;
import litll.idl.litlltext2entity.error.LitllFileToEntityError;
import litll.idl.std.entity.idl.LibraryName;
import litll.idl.std.entity.idl.library.LibraryVersion;
import litll.idl.std.entity.util.version.Version;
import litll.idl.std.litll2entity.idl.library.LibraryConfigLitllToEntity;

class LibraryScope
{
    public var map(default, null):Map<String, LibrarySeries>;
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
                    map[name] = new LibrarySeries(this, name);
                }
                
                var sourceReader = new IdlFileSourceReader();
                lib.add(file, name, sourceReader, config);
                
            case Result.Err(errors):
                for (e in errors) errorOutput.push(e);
        }
    }
    
    public function getReferencedLibrary(referencerFile:String, referencedName:LibraryName, version:LibraryVersion):Result<Library, Array<ReadIdlError>>
    {
        return if (map.exists(referencedName.data))
        {
            map[referencedName.data].getReferencedLibrary(referencerFile, version);
        }
        else
        {
            Result.Err(
                [
                    new ReadIdlError(
                        referencerFile,
                        ReadIdlErrorKind.LibraryNotFound(referencedName)
                    )
                ]
            );
        }
    }
}
