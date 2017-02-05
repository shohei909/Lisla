package litll.idl.generator.source;
import litll.core.ds.Maybe;
import litll.core.ds.Result;
import litll.idl.generator.error.IdlReadError;
import litll.idl.generator.source.validate.ValidType;
import litll.idl.std.data.idl.TypeDefinition;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.group.TypeGroupPath;

interface IdlSourceProvider
{
	public function resolveGroups(targets:Array<TypeGroupPath>):Result<Array<ValidType>, Array<IdlReadError>>;
    public function resolveTypePath(path:TypePath):Maybe<TypeDefinition>;
}
