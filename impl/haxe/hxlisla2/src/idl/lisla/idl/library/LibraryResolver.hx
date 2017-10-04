package arraytree.idl.library;
import hxext.ds.Result;
import arraytree.idl.generator.error.LibraryResolutionError;
import arraytree.idl.generator.error.LibraryFindError;
import arraytree.idl.generator.error.LoadIdlError;
import arraytree.idl.generator.source.IdlSourceProvider;
import arraytree.idl.library.error.ModuleResolutionError;
import arraytree.idl.std.entity.idl.LibraryName;
import arraytree.idl.std.entity.idl.ModulePath;

interface LibraryResolver
{
    public function resolveModuleElement(modulePath:ModulePath):Result<PackageElement, ModuleResolutionError>;
}
