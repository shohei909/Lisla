package lisla.idl.generator.error;
import haxe.ds.Option;
import lisla.data.meta.position.Range;
import lisla.error.core.ElementaryError;
import lisla.error.core.ErrorName;
import lisla.error.core.InlineError;
import lisla.idl.std.entity.idl.LibraryName;

class LibraryFindError implements ElementaryError
{
    public var libraryName(default, null):String;
    public var kind(default, null):LibraryFindErrorKind;
    
    public function new(
        kind:LibraryFindErrorKind,
        libraryName:String
    ) 
    {
        this.kind = kind;
        this.libraryName = libraryName;
    }
    
    public function getMessage():String
    {   
        return switch (kind)
        {
            case LibraryFindErrorKind.NotFound:
                "Library '" + libraryName + "' is not found";
            
            case LibraryFindErrorKind.VersionNotFound(version):
                "Library '" + libraryName + "' version '" + version.data + "' is not found";
        }
    }
    
    public function getErrorName():ErrorName
    {
        return ErrorName.fromEnum(kind);
    }
    
    public function getElementaryError():ElementaryError
    {
        return this;
    }
}
