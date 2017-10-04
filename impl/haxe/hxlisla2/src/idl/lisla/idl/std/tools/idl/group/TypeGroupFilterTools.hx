package lisla.idl.std.tools.idl.group;
import lisla.data.meta.core.tag;
import lisla.idl.std.entity.idl.group.TypeGroupFilter;
import lisla.idl.std.entity.idl.group.TypeGroupPath;

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