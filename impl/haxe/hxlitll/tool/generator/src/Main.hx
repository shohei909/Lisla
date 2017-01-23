package;

import haxe.ds.Option;
import haxe.io.Path;
import litll.core.ds.Maybe;
import litll.idl.project.IdlProject;
import litll.idl.std.data.idl.path.TypeGroupPath;
import litll.idl.std.data.idl.haxe.DataOutputConfig;
import litll.idl.std.data.idl.haxe.DelitllfierOutputConfig;
import litll.idl.std.data.idl.haxe.OutputConfig;
import litll.idl.std.data.idl.haxe.ProjectConfig;
import litll.idl.std.data.idl.haxe.SourceConfig;
import sys.FileSystem;
using litll.core.ds.ResultTools;

class Main 
{
	public static function main():Void
	{
		remove("../../migration/litll");
		var config = new ProjectConfig(
			new SourceConfig([], []),
			new OutputConfig(
				"../../migration",
				new DataOutputConfig(
					[
						TypeGroupPath.create("litll").getOrThrow(),
					],
					[]
				),
				Maybe.some(
					new DelitllfierOutputConfig(
						[
							TypeGroupPath.create("litll").getOrThrow(),
						],
						[]
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
