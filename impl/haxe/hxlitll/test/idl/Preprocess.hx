import haxe.io.Path;
import hxext.ds.Maybe;
import litll.idl.generator.IdlProject;
import litll.idl.generator.data.DataOutputConfig;
import litll.idl.generator.data.LitllToEntityOutputConfig;
import litll.idl.generator.data.OutputConfig;
import litll.idl.generator.data.ProjectConfig;
import litll.idl.generator.data.SourceConfig;
import litll.idl.std.data.idl.group.TypeGroupPath;
import litll.idl.std.tools.idl.path.TypePathFilterTools;
import litll.project.LitllProjectSystem;
import sys.FileSystem;
using hxext.ds.ResultTools;

class Preprocess 
{
    public static function main():Void
    {
        remove("migration/litll");
        
        // old
		var config = new ProjectConfig(
			new SourceConfig(
                [
                    "litll/idl",
                ],
                [
                ]
            ),
			new OutputConfig(
				"migration",
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
					new LitllToEntityOutputConfig(
						[
							TypeGroupPath.create("litll").getOrThrow(),
							TypeGroupPath.create("hxlitll").getOrThrow(),
						],
						[
                            TypePathFilterTools.createPrefix("hxlitll", "litll.idl.hxlitll.litll2entity"),
                        ]
					)
				)
			)
		);
        
        if (IdlProject.run("../../../data/idl", config))
		{
			Sys.exit(1);
		}
        
        // new
        var litllProject = LitllProjectSystem.getCurrentProject();
        if (litllProject.generateHaxe("litll/hxlitll/litll.hxinput.litll"))
		{
			Sys.exit(1);
		}
        
        if (litllProject.generateHaxe("litll/hxlitll/hxlitll.hxinput.litll"))
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
