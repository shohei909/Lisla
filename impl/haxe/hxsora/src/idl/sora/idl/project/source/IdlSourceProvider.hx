package sora.idl.project.source;
import sora.core.ds.Result;
import sora.idl.project.error.IdlReadError;
import sora.idl.std.data.idl.TypeDefinition;
import sora.idl.std.data.idl.TypePath;
import sora.idl.std.data.idl.path.TypeGroupPath;

interface IdlSourceProvider 
{
	public function resolveGroups(targets:Array<TypeGroupPath>):Result<Map<TypePath, TypeDefinition>, Array<IdlReadError>>;
}