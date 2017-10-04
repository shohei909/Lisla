package arraytree.idl.library;
import haxe.ds.Option;
import hxext.ds.OrderedMap;
import hxext.ds.Result;
import arraytree.idl.generator.error.LibraryFindError;
import arraytree.idl.generator.error.LibraryFindErrorKind;
import arraytree.project.FilePathFromProjectRoot;
import arraytree.idl.generator.error.LoadIdlError;
import arraytree.idl.generator.error.LoadIdlErrorKind;
import arraytree.idl.generator.source.IdlSourceReader;
import arraytree.idl.library.Library;
import arraytree.idl.std.entity.idl.library.LibraryConfig;
import arraytree.idl.std.entity.idl.LibraryName;
import arraytree.idl.std.entity.idl.library.LibraryVersion;
import arraytree.idl.std.entity.util.version.Version;
import arraytree.project.FileSourceMap;
import arraytree.project.FileSourceRange;
import arraytree.project.ProjectRootAndFilePath;
import arraytree.project.ProjectRootDirectory;

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
