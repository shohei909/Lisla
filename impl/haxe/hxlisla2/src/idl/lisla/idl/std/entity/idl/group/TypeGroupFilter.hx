package arraytree.idl.std.entity.idl.group;
import hxext.ds.Maybe;
import arraytree.idl.std.entity.idl.TypePath;

class TypeGroupFilter {
    public var from : TypeGroupPath;
    public var to : TypeGroupPath;
    public function new(from:TypeGroupPath, to:TypeGroupPath) {
        this.from = from;
        this.to = to;
    }
    
    public function apply(path:TypePath):Maybe<TypePath>
	{
		return from.filter(path, to);
	}
}