package litll.idl.generator.data;
import haxe.ds.Option;
import litll.idl.generator.output.entity.EntityHaxeTypePath;
import litll.idl.generator.output.litll2entity.path.HaxeLitllToEntityTypePath;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.group.TypeGroupPath;
import litll.idl.std.data.idl.group.TypePathFilter;

using hxext.ds.ResultTools;
using hxext.ds.MaybeTools;
using litll.idl.std.tools.idl.path.TypePathFilterTools;

class LitllToEntityOutputConfig
{
	public var targets:Array<TypeGroupPath>;
	public var filters:Array<TypePathFilter>;
	
	public function new(targets:Array<TypeGroupPath>, filters:Array<TypePathFilter>) 
	{
		this.targets = targets;
		this.filters = [
			TypePathFilter.Prefix(
				TypeGroupPath.create("litll").getOrThrow(), 
				TypeGroupPath.create("litll.idl.std.litll2entity").getOrThrow()
			)
		].concat(filters);
	}	
	
	public function toHaxeLitllToEntityPath(sourcePath:TypePath):HaxeLitllToEntityTypePath
	{
		var typePath = new TypePath(
			sourcePath.modulePath, 
			sourcePath.typeName.map(function (name) return name + "LitllToEntity"),
			sourcePath.tag
		);
		
		var l = filters.length;
		for (i in 0...l)
		{
			var filter = filters[l - i - 1];
			switch (filter.apply(typePath).toOption())
			{
				case Option.Some(convertedPath):
					typePath = convertedPath;
					break;
					
				case Option.None:
			}
		}
		
		return new HaxeLitllToEntityTypePath(typePath);
	}
}
