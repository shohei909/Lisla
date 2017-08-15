package lisla.idl.std.tools.idl.group;
import lisla.data.meta.core.Metadata;
import lisla.idl.std.entity.idl.group.TypeGroupFilter;
import lisla.idl.std.entity.idl.group.TypeGroupPath;

class TypeGroupFilterTools 
{
    public static function create(
        source:String, 
        destination:String
        // TODO: metadata?
    ):TypeGroupFilter
	{
        
		return new TypeGroupFilter(
			TypeGroupPath.create(source, new Metadata()).getOrThrow(),
			TypeGroupPath.create(destination, new Metadata()).getOrThrow()
		);
	}
}