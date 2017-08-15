package lisla.idl.library;
import haxe.ds.Option;
import hxext.ds.OrderedMap;
import hxext.ds.Result;
import lisla.idl.generator.error.LibraryFindError;
import lisla.idl.generator.error.LibraryFindErrorKind;
import lisla.project.FilePathFromProjectRoot;
import lisla.idl.generator.error.LoadIdlError;
import lisla.idl.generator.error.LoadIdlErrorKind;
import lisla.idl.generator.source.IdlSourceReader;
import lisla.idl.library.Library;
import lisla.idl.std.entity.idl.library.LibraryConfig;
import lisla.idl.std.entity.idl.LibraryName;
import lisla.idl.std.entity.idl.library.LibraryVersion;
import lisla.idl.std.entity.util.version.Version;
import lisla.project.FileSourceMap;
import lisla.project.FileSourceRange;
import lisla.project.ProjectRootAndFilePath;
import lisla.project.ProjectRootDirectory;

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
    
    public function add(
        name:String, 
        filePath:ProjectRootAndFilePath, 
        sourceReader:IdlSourceReader, 
        config:LibraryConfig,
        configFileSourceMap:Option<FileSourceMap>
    ):Void
    {
        var pack = new Library(
            this, 
            filePath, 
            name, 
            sourceReader, 
            config,
            configFileSourceMap
        );
        versions.set(config.version.data, pack);
    }
    
    public function getLibrary(
        version:LibraryVersion
    ):Result<Library, LibraryFindError>
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
                    Result.Error(
                        new LibraryFindError(
                            LibraryFindErrorKind.VersionNotFound(_version),
                            name
                        )
                    );
                }
        }
    }
}
