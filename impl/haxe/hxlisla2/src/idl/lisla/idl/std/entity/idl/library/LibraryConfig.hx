package lisla.idl.std.entity.idl.library;
import hxext.ds.Maybe;
import hxext.ds.Result;
import lisla.data.meta.core.StringWithMetadata;
import lisla.data.meta.core.Metadata;
import lisla.idl.lisla2entity.error.LislaToEntityErrorKind;
import lisla.idl.std.entity.util.version.Version;

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
        
        // TODO: use lislaToEntity
		var extensionMap = new Map();
        var libraryMap = new Map();
        for (extension in extensions)
        {
            if (extensionMap.exists(extension.target.data))
            {
                throw Result.Error(LislaToEntityErrorKind.Fatal("Extension " + extension.target.data + " is dupplicated"));
            }
            
            extensionMap[extension.target.data] = extension;
        }
        
        for (library in libraries)
        {
            if (libraryMap.exists(library.library.name.data))
            {
                throw Result.Error(LislaToEntityErrorKind.Fatal("Library " + library.library.name.data + " is dupplicated"));
            }
            
            libraryMap[library.library.name.data] = library.library;
        }
        
        this.extensions = extensionMap;
        this.libraries = libraryMap;
    }
    
    @:lislaToEntity
    public static function lislaToEntity(
        version:Version, 
        description:StringWithMetadata, 
        extensions:Array<FileExtensionDeclaration>, 
        libraries:Array<LibraryDependenceDeclaration>
    ):Result<LibraryConfig, LislaToEntityErrorKind> 
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
