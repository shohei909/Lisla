package arraytree.idl.generator.error;
import hxext.ds.Maybe;
import arraytree.data.tree.al.AlTree;
import arraytree.data.meta.core.Metadata;
import arraytree.idl.arraytreetext2entity.error.ArrayTreeTextToEntityError;
import arraytree.idl.arraytreetext2entity.error.ArrayTreeTextToEntityErrorKind;
import arraytree.idl.std.entity.idl.ModulePath;
import arraytree.idl.std.entity.idl.PackagePath;
import arraytree.idl.std.entity.idl.TypeName;
import arraytree.idl.std.entity.idl.TypePath;
import arraytree.idl.std.entity.idl.LibraryName;
import arraytree.idl.std.entity.util.version.Version;

enum LoadIdlErrorKind
{
    // 
    LibraryFactor(error:IdlLibraryFactorError);
    
    // 
    ModuleFactor(error:IdlModuleFactorError);
}
