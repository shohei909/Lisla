package lisla.idl.library;
import hxext.ds.OrderedMap;
import hxext.ds.Result;
import lisla.idl.generator.error.LoadIdlError;
import lisla.idl.generator.error.LoadIdlErrorKind;
import lisla.idl.generator.source.IdlSourceReader;
import lisla.idl.library.Library;
import lisla.idl.std.entity.idl.library.LibraryConfig;
import lisla.idl.std.entity.idl.LibraryName;
import lisla.idl.std.entity.idl.library.LibraryVersion;
import lisla.idl.std.entity.util.version.Version;

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