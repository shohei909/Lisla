package lisla.idl.generator.data;
import haxe.ds.Option;
import lisla.idl.generator.output.lisla2entity.path.HaxeLislaToEntityTypePath;
import lisla.idl.hxlisla.entity.LislaToEntityConfig;
import lisla.idl.std.entity.idl.TypePath;
import lisla.idl.std.entity.idl.group.TypeGroupFilter;
import lisla.idl.std.tools.idl.group.TypeGroupFilterTools;

using hxext.ds.ResultTools;

class LislaToEntityOutputConfig
{
	public var filters:Array<TypeGroupFilter>;
	public var noOutput:Bool;
    
	public function new(noOutput:Bool, filters:Array<TypeGroupFilter>) 
	{
        this.noOutput = noOutput;
		this.filters = filters.concat(
            [
                TypeGroupFilterTools.create("ArrayLislaToEntity", "lisla.idl.std.lisla2entity.ArrayLislaToEntity"),
                TypeGroupFilterTools.create("StringLislaToEntity", "lisla.idl.std.lisla2entity.StringLislaToEntity"),
            ]
        );
	}
	
	public function toHaxeLislaToEntityPath(sourcePath:TypePath):HaxeLislaToEntityTypePath
	{
		var typePath = new TypePath(
			sourcePath.modulePath, 
			sourcePath.typeName.map(function (name) return name + "LislaToEntity"),
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
		
		return new HaxeLislaToEntityTypePath(typePath);
	}
}
