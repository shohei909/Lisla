package litll.idl.std.tools.idl.group;
import litll.idl.std.entity.idl.group.TypeGroupFilter;
import litll.idl.std.entity.idl.group.TypeGroupPath;

class TypeGroupFilterTools 
{
    public static function create(source:String, destination:String):TypeGroupFilter
	{
		return new TypeGroupFilter(
			TypeGroupPath.create(source).getOrThrow(),
			TypeGroupPath.create(destination).getOrThrow()
		);
	}
}