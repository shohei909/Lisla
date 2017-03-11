package litll.idl.library;
import hxext.ds.OrderedMap;
import hxext.ds.Result;
import litll.idl.generator.error.LoadIdlError;
import litll.idl.generator.error.LoadIdlErrorKind;
import litll.idl.generator.source.IdlSourceReader;
import litll.idl.library.Library;
import litll.idl.std.entity.idl.library.LibraryConfig;
import litll.idl.std.entity.idl.LibraryName;
import litll.idl.std.entity.idl.library.LibraryVersion;
import litll.idl.std.entity.util.version.Version;

class LibrarySeries
{
    public var versions(default, null):OrderedMap<String, Library>;
    public var name(default, null):String;
    public var scope(default, null):LibraryScope;
    
    public function new(scope:LibraryScope, name:String) 
    {
        this.scope = scope;
        this.name = name;
        versions = new OrderedMap();
    }
    
    public function add(path:String, name:String, sourceReader:IdlSourceReader, config:LibraryConfig):Void
    {
        var pack = new Library(this, path, name, sourceReader, config);
        versions.set(config.version.data, pack);
    }
    
    public function getReferencedLibrary(referencerFile:String, version:LibraryVersion) :Result<Library, Array<LoadIdlError>>
    {
        return switch (version)
        {
            case LibraryVersion.Version(_version):
                if (versions.exists(_version.data))
                {
                    Result.Ok(versions[_version.data]);
                }
                else
                {
                    Result.Err(
                        [
                            new LoadIdlError(
                                referencerFile,
                                LoadIdlErrorKind.LibraryVersionNotFound(name, _version)
                            )
                        ]
                    );
                }
        }
    }
}
