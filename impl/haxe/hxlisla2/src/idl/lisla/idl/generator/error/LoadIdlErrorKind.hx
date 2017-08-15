package lisla.idl.generator.error;
import hxext.ds.Maybe;
import lisla.data.tree.al.AlTree;
import lisla.data.meta.core.Metadata;
import lisla.idl.lislatext2entity.error.LislaTextToEntityError;
import lisla.idl.lislatext2entity.error.LislaTextToEntityErrorKind;
import lisla.idl.std.entity.idl.ModulePath;
import lisla.idl.std.entity.idl.PackagePath;
import lisla.idl.std.entity.idl.TypeName;
import lisla.idl.std.entity.idl.TypePath;
import lisla.idl.std.entity.idl.LibraryName;
import lisla.idl.std.entity.util.version.Version;

enum LoadIdlErrorKind
{
    // 
    LibraryFactor(error:IdlLibraryFactorError);
    
    // 
    ModuleFactor(error:IdlModuleFactorError);
}
