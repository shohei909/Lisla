package litll.idl.std.tools.idl.path;
import hxext.ds.Maybe;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.group.TypeGroupPath;
import litll.idl.std.data.idl.group.TypePathFilter;
using hxext.ds.ResultTools;

class TypePathFilterTools
{
	public static inline function apply(filter:TypePathFilter, path:TypePath):Maybe<TypePath>
	{
		return switch (filter)
		{
			case Prefix(source, dest):
				source.filter(path, dest);
		}
	}
	
	public static function createPrefix(source:String, destination:String) 
	{
		return TypePathFilter.Prefix(
			TypeGroupPath.create(source).getOrThrow(),
			TypeGroupPath.create(destination).getOrThrow()
		);
	}
}
