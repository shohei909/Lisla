package arraytree.idl.generator.source;
import hxext.ds.Maybe;
import hxext.ds.Result;
import arraytree.idl.generator.error.LoadIdlError;
import arraytree.idl.generator.source.validate.ValidType;
import arraytree.idl.std.entity.idl.TypeDefinition;
import arraytree.idl.std.entity.idl.TypePath;
import arraytree.idl.std.entity.idl.group.TypeGroupPath;

interface IdlSourceProvider
{
    public function resolveTypePath(path:TypePath):Maybe<TypeDefinition>;
}
