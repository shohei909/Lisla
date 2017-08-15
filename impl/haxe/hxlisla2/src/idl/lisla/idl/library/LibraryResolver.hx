package lisla.idl.library;
import hxext.ds.Result;
import lisla.idl.generator.error.LibraryResolutionError;
import lisla.idl.generator.error.LibraryFindError;
import lisla.idl.generator.error.LoadIdlError;
import lisla.idl.generator.source.IdlSourceProvider;
import lisla.idl.library.error.ModuleResolutionError;
import lisla.idl.std.entity.idl.LibraryName;
import lisla.idl.std.entity.idl.ModulePath;

interface LibraryResolver
{
    public function resolveModuleElement(modulePath:ModulePath):Result<PackageElement, ModuleResolutionError>;
}
