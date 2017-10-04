package arraytree.idl.generator.error;

enum IdlLibraryFactorErrorKind 
{
    LibraryResolution(error:LibraryResolutionError);
    NotFound(error:ModuleNotFoundError);    
}
