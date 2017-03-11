package lisla.idl.library;
import hxext.ds.Result;
import lisla.idl.generator.error.LoadIdlError;
import lisla.idl.generator.source.IdlSourceProvider;
import lisla.idl.std.entity.idl.LibraryName;

interface LibraryResolver
{
    public function getReferencedLibrary(referencerFile:String, referencedName:LibraryName):Result<Library, Array<LoadIdlError>>;
}