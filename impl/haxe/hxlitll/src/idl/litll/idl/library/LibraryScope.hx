package lisla.idl.library;
import haxe.io.Path;
import hxext.ds.Result;
import lisla.core.LislaString;
import lisla.idl.generator.error.LoadIdlError;
import lisla.idl.generator.error.LoadIdlErrorKind;
import lisla.idl.generator.source.IdlFileSourceReader;
import lisla.idl.generator.source.validate.ValidType;
import lisla.idl.lislatext2entity.LislaFileToEntityRunner;
import lisla.idl.lislatext2entity.error.LislaFileToEntityError;
import lisla.idl.std.entity.idl.LibraryName;
import lisla.idl.std.entity.idl.library.LibraryVersion;
import lisla.idl.std.entity.util.version.Version;
import lisla.idl.std.lisla2entity.idl.library.LibraryConfigLislaToEntity;

class LibraryScope
{
    public var map(default, null):Map<String, LibrarySeries>;
    public function new() 
    {
        map = new Map();
    }
    
    public function read(name:String, file:String, errorOutput:Array<LislaFileToEntityError>):Void
    {
        return switch(LislaFileToEntityRunner.run(LibraryConfigLislaToEntity, file))
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
    
    public function getReferencedLibrary(referencerFile:String, referencedName:LibraryName, version:LibraryVersion):Result<Library, Array<LoadIdlError>>
    {
        return if (map.exists(referencedName.data))
        {
            map[referencedName.data].getReferencedLibrary(referencerFile, version);
        }
        else
        {
            Result.Err(
                [
                    new LoadIdlError(
                        referencerFile,
                        LoadIdlErrorKind.LibraryNotFound(referencedName)
                    )
                ]
            );
        }
    }
}
