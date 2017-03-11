package lisla.idl.generator.source;
import hxext.ds.Maybe;
import hxext.ds.Result;
import lisla.idl.generator.error.LoadIdlError;
import lisla.idl.generator.source.validate.ValidType;
import lisla.idl.std.entity.idl.TypeDefinition;
import lisla.idl.std.entity.idl.TypePath;
import lisla.idl.std.entity.idl.group.TypeGroupPath;

interface IdlSourceProvider
{
    public function resolveTypePath(path:TypePath):Maybe<TypeDefinition>;
}
