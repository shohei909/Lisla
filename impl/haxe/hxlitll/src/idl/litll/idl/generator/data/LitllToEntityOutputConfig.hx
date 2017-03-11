package litll.idl.generator.data;
import haxe.ds.Option;
import litll.idl.generator.output.litll2entity.path.HaxeLitllToEntityTypePath;
import litll.idl.std.entity.idl.TypePath;
import litll.idl.std.entity.idl.group.TypeGroupFilter;
import litll.idl.std.tools.idl.group.TypeGroupFilterTools;

using hxext.ds.ResultTools;

class LitllToEntityOutputConfig
{
	public var filters:Array<TypeGroupFilter>;
	
	public function new(filters:Array<TypeGroupFilter>) 
	{
		this.filters = filters.concat(
            [
                TypeGroupFilterTools.create("ArrayLitllToEntity", "litll.idl.std.litll2entity.ArrayLitllToEntity"),
                TypeGroupFilterTools.create("StringLitllToEntity", "litll.idl.std.litll2entity.StringLitllToEntity"),
            ]
        );
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
