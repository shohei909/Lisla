package litll.idl.std.tools.idl.group;
import litll.idl.std.data.idl.group.TypeGroupFilter;
import litll.idl.std.data.idl.group.TypeGroupPath;

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