package litll.idl.std.entity.idl.library;
import hxext.ds.Maybe;
import hxext.ds.Result;
import litll.core.LitllString;
import litll.core.tag.ArrayTag;
import litll.idl.litll2entity.error.LitllToEntityErrorKind;
import litll.idl.std.entity.util.version.Version;

class LibraryConfig 
{
    public var version : Version;
    public var description : LitllString;
    public var extensions : Map<String, FileExtensionDeclaration>;
    public var libraries : Map<String, LibraryReference>;
    public var tag:Maybe<ArrayTag>;
    
    public function new(
        version:Version, 
        description:LitllString, 
        extensions:Array<FileExtensionDeclaration>, 
        libraries:Array<LibraryDependenceDeclaration>,
        
        // TODO: Not optional
        ?tag:Maybe<ArrayTag>
    )
    {
        this.tag = tag;
        this.version = version;
        this.description = description;
        
        // TODO: use litllToEntity
		var extensionMap = new Map();
        var libraryMap = new Map();
        for (extension in extensions)
        {
            if (extensionMap.exists(extension.target.data))
            {
                throw Result.Err(LitllToEntityErrorKind.Fatal("Extension " + extension.target.data + " is dupplicated"));
            }
            
            extensionMap[extension.target.data] = extension;
        }
        
        for (library in libraries)
        {
            if (libraryMap.exists(library.library.name.data))
            {
                throw Result.Err(LitllToEntityErrorKind.Fatal("Library " + library.library.name.data + " is dupplicated"));
            }
            
            libraryMap[library.library.name.data] = library.library;
        }
        
        this.extensions = extensionMap;
        this.libraries = libraryMap;
        this.tag = tag;
    }
    
    @:litllToEntity
    public static function litllToEntity(
        version:Version, 
        description:LitllString, 
        extensions:Array<FileExtensionDeclaration>, 
        libraries:Array<LibraryDependenceDeclaration>
    ):Result<LibraryConfig, LitllToEntityErrorKind> // TODO: Array error
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
