package arraytree.idl.std.entity.idl.library;
import hxext.ds.Maybe;
import hxext.ds.Result;
import arraytree.data.meta.core.StringWithMetadata;
import arraytree.data.meta.core.Metadata;
import arraytree.idl.arraytree2entity.error.ArrayTreeToEntityErrorKind;
import arraytree.idl.std.entity.util.version.Version;

class LibraryConfig 
{
    public var version:Version;
    public var description:StringWithMetadata;
    public var extensions:Map<String, FileExtensionDeclaration>;
    public var libraries:Map<String, LibraryReference>;
    
    public function new(
        version:Version, 
        description:StringWithMetadata, 
        extensions:Array<FileExtensionDeclaration>, 
        libraries:Array<LibraryDependenceDeclaration>
    )
    {
        this.version = version;
        this.description = description;
        
        // TODO: use arraytreeToEntity
		var extensionMap = new Map();
        var libraryMap = new Map();
        for (extension in extensions)
        {
            if (extensionMap.exists(extension.target.data))
            {
                throw Result.Error(ArrayTreeToEntityErrorKind.Fatal("Extension " + extension.target.data + " is dupplicated"));
            }
            
            extensionMap[extension.target.data] = extension;
        }
        
        for (library in libraries)
        {
            if (libraryMap.exists(library.library.name.data))
            {
                throw Result.Error(ArrayTreeToEntityErrorKind.Fatal("Library " + library.library.name.data + " is dupplicated"));
            }
            
            libraryMap[library.library.name.data] = library.library;
        }
        
        this.extensions = extensionMap;
        this.libraries = libraryMap;
    }
    
    @:arraytreeToEntity
    public static function arraytreeToEntity(
        version:Version, 
        description:StringWithMetadata, 
        extensions:Array<FileExtensionDeclaration>, 
        libraries:Array<LibraryDependenceDeclaration>
    ):Result<LibraryConfig, ArrayTreeToEntityErrorKind> 
	{
        return Result.Ok(
            new LibraryConfig(
                version, 
                description,
                extensions,
                libraries
            )
        );
	}
}
