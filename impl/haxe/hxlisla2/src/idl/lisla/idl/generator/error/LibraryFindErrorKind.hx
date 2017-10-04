package arraytree.idl.generator.error;
import arraytree.idl.std.entity.idl.LibraryName;
import arraytree.idl.std.entity.util.version.Version;

enum LibraryFindErrorKind
{
    // Library
    NotFound;
    VersionNotFound(version:Version);
}
