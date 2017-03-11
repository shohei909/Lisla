package litll.idl.generator.source;
import hxext.ds.Maybe;
import hxext.ds.Result;
import litll.idl.generator.error.ReadIdlError;
import litll.idl.generator.source.validate.ValidType;
import litll.idl.std.data.idl.TypeDefinition;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.group.TypeGroupPath;

interface IdlSourceProvider
{
    public function resolveTypePath(path:TypePath):Maybe<TypeDefinition>;
}
