package sora.idl.std.data.idl.project;
import haxe.ds.Option;
import sora.idl.project.output.path.HaxeDataTypePath;
import sora.idl.project.output.path.HaxeDesoralizerTypePath;
import sora.idl.std.data.idl.TypeName;
import sora.idl.std.data.idl.TypePath;
import sora.idl.std.data.idl.path.TypeGroupPath;
import sora.idl.std.data.idl.path.TypePathFilter;

using sora.core.ds.ResultTools;
using sora.core.ds.OptionTools;
using sora.idl.std.tools.idl.path.TypePathFilterTools;

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
				TypeGroupPath.create("sora.idl.std.desoralize").getOrThrow()
			)
		].concat(filters);
	}	
	
	public function toHaxeDesoralizerPath(sourcePath:TypePath):HaxeDesoralizerTypePath
	{
		var typePath = new TypePath(sourcePath.modulePath, new TypeName(sourcePath.typeName.toString() + "Desoralizer"));
		var l = filters.length;
		for (i in 0...l)
		{
			var filter = filters[l - i - 1];
			switch (filter.apply(typePath))
			{
				case Option.Some(convertedPath):
					typePath = convertedPath;
					break;
					
				case Option.None:
			}
		}
		
		return new HaxeDesoralizerTypePath(typePath);
	}
}
