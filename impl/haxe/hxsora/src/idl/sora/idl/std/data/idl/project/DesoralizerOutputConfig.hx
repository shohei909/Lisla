package sora.idl.std.data.idl.project;
import sora.idl.std.data.idl.path.TypeGroupPath;
import sora.idl.std.data.idl.path.TypePathFilter;
using sora.core.ds.ResultTools;

class DesoralizerOutputConfig
{
	public var targets:Array<TypeGroupPath>;
	public var filters:Array<TypePathFilter>;
	
	public function new(targets:Array<TypeGroupPath>, filters:Array<TypePathFilter>) 
	{
		this.targets = targets;
		this.filters = [
			TypePathFilter.Prefix(
				TypeGroupPath.create("sora").getOrThrow(), 
				TypeGroupPath.create("sora.idl.desoralizer").getOrThrow()
			)
		].concat(filters);
	}	
}
