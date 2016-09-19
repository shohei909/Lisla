package sora.idl.std.tools.idl.path;
import haxe.ds.Option;
import sora.idl.std.data.idl.TypePath;
import sora.idl.std.data.idl.path.TypeGroupPath;
import sora.idl.std.data.idl.path.TypePathFilter;
using sora.core.ds.ResultTools;

class TypePathFilterTools
{
	public static inline function apply(filter:TypePathFilter, path:TypePath):Option<TypePath>
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
