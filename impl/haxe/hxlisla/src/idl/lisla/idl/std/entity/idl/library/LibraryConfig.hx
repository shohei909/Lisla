package lisla.idl.std.entity.idl.library;
import hxext.ds.Maybe;
import hxext.ds.Result;
import lisla.core.LislaString;
import lisla.core.tag.ArrayTag;
import lisla.idl.lisla2entity.error.LislaToEntityErrorKind;
import lisla.idl.std.entity.util.version.Version;

class LibraryConfig 
{
    public var version : Version;
    public var description : LislaString;
    public var extensions : Map<String, FileExtensionDeclaration>;
    public var libraries : Map<String, LibraryReference>;
    public var tag:Maybe<ArrayTag>;
    
    public function new(
        version:Version, 
        description:LislaString, 
        extensions:Array<FileExtensionDeclaration>, 
        libraries:Array<LibraryDependenceDeclaration>,
        
        // TODO: Not optional
        ?tag:Maybe<ArrayTag>
    )
    {
        this.tag = tag;
        this.version = version;
        this.description = description;
        
        // TODO: use lislaToEntity
		var extensionMap = new Map();
        var libraryMap = new Map();
        for (extension in extensions)
        {
            if (extensionMap.exists(extension.target.data))
            {
                throw Result.Err(LislaToEntityErrorKind.Fatal("Extension " + extension.target.data + " is dupplicated"));
            }
            
            extensionMap[extension.target.data] = extension;
        }
        
        for (library in libraries)
        {
            if (libraryMap.exists(library.library.name.data))
            {
                throw Result.Err(LislaToEntityErrorKind.Fatal("Library " + library.library.name.data + " is dupplicated"));
            }
            
            libraryMap[library.library.name.data] = library.library;
        }
        
        this.extensions = extensionMap;
        this.libraries = libraryMap;
        this.tag = tag;
    }
    
    @:lislaToEntity
    public static function lislaToEntity(
        version:Version, 
        description:LislaString, 
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
