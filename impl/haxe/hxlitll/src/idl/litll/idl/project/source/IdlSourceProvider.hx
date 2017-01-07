package litll.idl.project.source;
import litll.core.ds.Result;
import litll.idl.project.error.IdlReadError;
import litll.idl.std.data.idl.TypeDefinition;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.path.TypeGroupPath;

interface IdlSourceProvider 
{
	public function resolveGroups(targets:Array<TypeGroupPath>):Result<Map<String, TypeDefinition>, Array<IdlReadError>>;
}