import haxe.io.Path;
import litll.core.ds.Maybe;
import litll.idl.generator.IdlProject;
import litll.idl.generator.data.DataOutputConfig;
import litll.idl.generator.data.DelitllfierOutputConfig;
import litll.idl.generator.data.OutputConfig;
import litll.idl.generator.data.ProjectConfig;
import litll.idl.generator.data.SourceConfig;
import litll.idl.std.data.idl.group.TypeGroupPath;
import litll.idl.std.tools.idl.path.TypePathFilterTools;
import sys.FileSystem;
using litll.core.ds.ResultTools;

// import litll.idl.hxlitll.delitllfy.idl.config.InputFileDelitllfier;

class Main 
{
	public static function main():Void
	{
//        var hxinputData = File.getContent("litll/hxlitll/hxlitll.hxinput.litll");
//        LitllStringToData.run(InputFileDelitllfier, hxinputData);

        remove("../../migration/litll");
		var config = new ProjectConfig(
			new SourceConfig(
                [
                    "litll/idl"
                ],
                [
                ]
            ),
			new OutputConfig(
				"../../migration",
				new DataOutputConfig(
					[
						TypeGroupPath.create("litll").getOrThrow(),
						TypeGroupPath.create("hxlitll").getOrThrow(),
					],
					[
                        TypePathFilterTools.createPrefix("hxlitll", "litll.idl.hxlitll.data"),
                    ]
				),
				Maybe.some(
					new DelitllfierOutputConfig(
						[
							TypeGroupPath.create("litll").getOrThrow(),
							TypeGroupPath.create("hxlitll").getOrThrow(),
						],
						[
                            TypePathFilterTools.createPrefix("hxlitll", "litll.idl.hxlitll.delitllfy"),
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
