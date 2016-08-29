package sora.idl.std.data.idl.project;
import sora.idl.std.data.idl.path.TypeGroupPath;
import sora.idl.std.data.idl.path.TypeRenameFilter;
using sora.core.ds.ResultTools;

class DataOutputConfig
{
	public var targets:Array<TypeGroupPath>;
	public var filters:Array<TypeRenameFilter>;
	
	public function new(targets:Array<TypeGroupPath>, filters:Array<TypeRenameFilter>) 
	{
		this.targets = targets;
		this.filters = [	
			TypeRenameFilter.Prefix(
				TypeGroupPath.create("sora").getOrThrow(), 
				TypeGroupPath.create("sora.idl.data").getOrThrow()
			)
		].concat(filters);
	}
}
