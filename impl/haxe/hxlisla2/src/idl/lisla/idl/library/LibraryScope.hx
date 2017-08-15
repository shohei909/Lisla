package lisla.idl.library;
import haxe.ds.Option;
import hxext.ds.Result;
import lisla.idl.generator.error.LibraryFindError;
import lisla.idl.generator.error.LibraryFindErrorKind;
import lisla.idl.generator.source.IdlFileSourceReader;
import lisla.idl.lislatext2entity.LislaFileToEntityRunner;
import lisla.idl.lislatext2entity.error.LislaFileToEntityError;
import lisla.idl.std.entity.idl.LibraryName;
import lisla.idl.std.entity.idl.library.LibraryVersion;
import lisla.idl.std.lisla2entity.idl.library.LibraryConfigLislaToEntity;
import lisla.project.ProjectRootAndFilePath;

class LibraryScope
{
    public var map(default, null):Map<String, LibrarySeries>;
    public function new() 
    {
        map = new Map();
    }
    
    public function read(
        name:String, 
        filePath:ProjectRootAndFilePath, 
        errorOutput:Array<LislaFileToEntityError>
    ):Void
    {
        switch(LislaFileToEntityRunner.run(filePath, LibraryConfigLislaToEntity))
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
                
                var sourceReader = new IdlFileSourceReader(filePath.projectRoot);
                lib.add(
                    name, 
                    filePath, 
                    sourceReader, 
                    config.data,
                    Option.Some(config.getFileSourceMap())
                );
                
            case Result.Error(errors):
                for (error in errors)
                {
                    errorOutput.push(error);
                }
        }
    }
    
    public function getLibrary(
        libraryName:LibraryName, 
        version:LibraryVersion
    ):Result<Library, LibraryFindError>
    {
        return if (map.exists(libraryName.data))
        {
            map[libraryName.data].getLibrary(version);
        }
        else
        {
            Result.Error(
                new LibraryFindError(
                    LibraryFindErrorKind.NotFound,
                    libraryName.data
                )
            );
        }
    }
}
