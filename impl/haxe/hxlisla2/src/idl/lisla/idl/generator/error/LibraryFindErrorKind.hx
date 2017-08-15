package lisla.idl.generator.error;
import lisla.idl.std.entity.idl.LibraryName;
import lisla.idl.std.entity.util.version.Version;

enum LibraryFindErrorKind
{
    // Library
    NotFound;
    VersionNotFound(version:Version);
}
