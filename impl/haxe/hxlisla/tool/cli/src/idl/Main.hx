import haxe.io.Path;
import lisla.core.ds.Maybe;
import lisla.idl.generator.IdlProject;
import lisla.idl.generator.data.DataOutputConfig;
import lisla.idl.generator.data.LislaToEntityOutputConfig;
import lisla.idl.generator.data.OutputConfig;
import lisla.idl.generator.data.ProjectConfig;
import lisla.idl.generator.data.SourceConfig;
import lisla.idl.std.data.idl.group.TypeGroupPath;
import lisla.idl.std.tools.idl.path.TypePathFilterTools;
import sys.FileSystem;
using hxext.ds.ResultTools;

// import lisla.idl.hxlisla.lisla2entity.idl.config.InputFileLislaToEntity;

class Main 
{
	public static function main():Void
	{
//        var hxinputData = File.getContent("lisla/hxlisla/hxlisla.hxinput.lisla");
//        LislaStringToData.run(InputFileLislaToEntity, hxinputData);

        remove("../../migration/lisla");
		var config = new ProjectConfig(
			new SourceConfig(
                [
                    "lisla/idl"
                ],
                [
                ]
            ),
			new OutputConfig(
				"../../migration",
				new DataOutputConfig(
					[
						TypeGroupPath.create("lisla").getOrThrow(),
						TypeGroupPath.create("hxlisla").getOrThrow(),
					],
					[
                        TypePathFilterTools.createPrefix("hxlisla", "lisla.idl.hxlisla.data"),
                    ]
				),
				Maybe.some(
					new LislaToEntityOutputConfig(
						[
							TypeGroupPath.create("lisla").getOrThrow(),
							TypeGroupPath.create("hxlisla").getOrThrow(),
						],
						[
                            TypePathFilterTools.createPrefix("hxlisla", "lisla.idl.hxlisla.lisla2entity"),
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
