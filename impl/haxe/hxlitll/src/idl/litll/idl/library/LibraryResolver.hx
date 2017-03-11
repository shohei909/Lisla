package litll.idl.library;
import hxext.ds.Result;
import litll.idl.generator.error.ReadIdlError;
import litll.idl.generator.source.IdlSourceProvider;
import litll.idl.std.data.idl.LibraryName;

interface LibraryResolver
{
    public function getReferencedLibrary(referencerFile:String, referencedName:LibraryName):Result<Library, Array<ReadIdlError>>;
}