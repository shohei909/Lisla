import haxe.ds.Option;
import haxe.io.Path;
import litll.core.ds.Maybe;
import litll.core.ds.Result;
import litll.core.parse.Parser;
import litll.idl.delitllfy.Delitllfier;
import litll.idl.project.IdlProject;
import litll.idl.project.data.DataOutputConfig;
import litll.idl.project.data.DelitllfierOutputConfig;
import litll.idl.project.data.OutputConfig;
import litll.idl.project.data.ProjectConfig;
import litll.idl.project.data.SourceConfig;
import litll.idl.std.data.idl.path.TypeGroupPath;
import litll.idl.std.tools.idl.path.TypePathFilterTools;
import sys.FileSystem;
import sys.io.File;
using litll.core.ds.ResultTools;

class Main 
{
	public static function main():Void
	{
        var hxinputData = File.getContent("litll/hxlitll/hxlitll.hxinput.litll");
        
        switch (Parser.run(content))
        {
            case Result.Err(error):
                throw error;
                
            case Result.Ok(litllArray):
                switch (Delitllfier.run(new InputFle, litllArray, config))
                {
                    case Result.Err(error):
                        errorResult(IdlReadErrorKind.Delitll(error));
                        
                    case Result.Ok(idl):
                        switch (loadedIdl.toOption())
                        {
                            case Option.Some(prevIdl):
                                errorResult(IdlReadErrorKind.ModuleDupplicated(new ModulePath(path), prevIdl.file));
                                
                            case Option.None:
                                loadedIdl = Maybe.some(new LoadedIdl(idl, filePath));
                        }
                }
        }
        
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
					],
					[
                        TypePathFilterTools.createPrefix("hxlitll", "litll.idl.hxlitll.data"),
                    ]
				),
				Maybe.some(
					new DelitllfierOutputConfig(
						[
							TypeGroupPath.create("litll").getOrThrow(),
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
