package arraytree.idl.generator.data;
import haxe.ds.Option;
import arraytree.idl.generator.output.arraytree2entity.path.HaxeArrayTreeToEntityTypePath;
import arraytree.idl.hxarraytree.entity.ArrayTreeToEntityConfig;
import arraytree.idl.std.entity.idl.TypePath;
import arraytree.idl.std.entity.idl.group.TypeGroupFilter;
import arraytree.idl.std.tools.idl.group.TypeGroupFilterTools;

using hxext.ds.ResultTools;

class ArrayTreeToEntityOutputConfig
{
	public var filters:Array<TypeGroupFilter>;
	public var noOutput:Bool;
    
	public function new(noOutput:Bool, filters:Array<TypeGroupFilter>) 
	{
        this.noOutput = noOutput;
		this.filters = filters.concat(
            [
                TypeGroupFilterTools.create("ArrayArrayTreeToEntity", "arraytree.idl.std.arraytree2entity.ArrayArrayTreeToEntity"),
                TypeGroupFilterTools.create("StringArrayTreeToEntity", "arraytree.idl.std.arraytree2entity.StringArrayTreeToEntity"),
            ]
        );
	}
	
	public function toHaxeArrayTreeToEntityPath(sourcePath:TypePath):HaxeArrayTreeToEntityTypePath
	{
		var typePath = new TypePath(
			sourcePath.modulePath, 
			sourcePath.typeName.map(function (name) return name + "ArrayTreeToEntity"),
			sourcePath.metadata
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
		
		return new HaxeArrayTreeToEntityTypePath(typePath);
	}
}
