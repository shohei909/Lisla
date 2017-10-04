import haxe.io.Path;
import arraytree.core.ds.Maybe;
import arraytree.idl.generator.IdlProject;
import arraytree.idl.generator.data.DataOutputConfig;
import arraytree.idl.generator.data.ArrayTreeToEntityOutputConfig;
import arraytree.idl.generator.data.OutputConfig;
import arraytree.idl.generator.data.ProjectConfig;
import arraytree.idl.generator.data.SourceConfig;
import arraytree.idl.std.data.idl.group.TypeGroupPath;
import arraytree.idl.std.tools.idl.path.TypePathFilterTools;
import sys.FileSystem;
using hxext.ds.ResultTools;

// import arraytree.idl.hxarraytree.arraytree2entity.idl.config.InputFileArrayTreeToEntity;

class Main 
{
	public static function main():Void
	{
//        var hxinputData = File.getContent("arraytree/hxarraytree/hxarraytree.hxinput.arraytree");
//        ArrayTreeStringToData.run(InputFileArrayTreeToEntity, hxinputData);

        remove("../../migration/arraytree");
		var config = new ProjectConfig(
			new SourceConfig(
                [
                    "arraytree/idl"
                ],
                [
                ]
            ),
			new OutputConfig(
				"../../migration",
				new DataOutputConfig(
					[
						TypeGroupPath.create("arraytree").getOrThrow(),
						TypeGroupPath.create("hxarraytree").getOrThrow(),
					],
					[
                        TypePathFilterTools.createPrefix("hxarraytree", "arraytree.idl.hxarraytree.data"),
                    ]
				),
				Maybe.some(
					new ArrayTreeToEntityOutputConfig(
						[
							TypeGroupPath.create("arraytree").getOrThrow(),
							TypeGroupPath.create("hxarraytree").getOrThrow(),
						],
						[
                            TypePathFilterTools.createPrefix("hxarraytree", "arraytree.idl.hxarraytree.arraytree2entity"),
                        ]
					)
				)
			)
		);
		
		if (IdlProject.run("../../../../../data/idl", config))
		{
			Sys.exit(1);
		}
	}
	
	public static function remove(file:String):Void 
	{
		if (FileSystem.exists(file)) 
		{
			if (FileSystem.isDirectory(file)) 
			{
				for (item in FileSystem.readDirectory(file)) 
				{
					item = Path.join([file, item]);
					remove(item);
				}
				FileSystem.deleteDirectory(file);
			} 
			else
			{
				FileSystem.deleteFile(file);
			}
		}
	}
}
