package litll.idl.std.data.idl.group;
import hxext.ds.Maybe;

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