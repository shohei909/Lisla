package arraytree.idl.std.tools.idl.group;
import arraytree.data.meta.core.tag;
import arraytree.idl.std.entity.idl.group.TypeGroupFilter;
import arraytree.idl.std.entity.idl.group.TypeGroupPath;

class TypeGroupFilterTools 
{
    public static function create(
        source:String, 
        destination:String
        // TODO: tag?
    ):TypeGroupFilter
	{
        
		return new TypeGroupFilter(
			TypeGroupPath.create(source, new tag()).getOrThrow(),
			TypeGroupPath.create(destination, new tag()).getOrThrow()
		);
	}
}