package arraytree.idl.library;
import haxe.ds.Option;
import hxext.ds.Result;
import arraytree.idl.generator.error.LibraryFindError;
import arraytree.idl.generator.error.LibraryFindErrorKind;
import arraytree.idl.generator.source.IdlFileSourceReader;
import arraytree.idl.arraytreetext2entity.ArrayTreeFileToEntityRunner;
import arraytree.idl.arraytreetext2entity.error.ArrayTreeFileToEntityError;
import arraytree.idl.std.entity.idl.LibraryName;
import arraytree.idl.std.entity.idl.library.LibraryVersion;
import arraytree.idl.std.arraytree2entity.idl.library.LibraryConfigArrayTreeToEntity;
import arraytree.project.ProjectRootAndFilePath;

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
        errorOutput:Array<ArrayTreeFileToEntityError>
    ):Void
    {
        switch(ArrayTreeFileToEntityRunner.run(filePath, LibraryConfigArrayTreeToEntity))
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
