package litll.idl.generator;

import haxe.ds.Option;
import haxe.io.Path;
import litll.idl.project.IdlProject;
import litll.idl.std.data.idl.path.TypeGroupPath;
import litll.idl.std.data.idl.project.DataOutputConfig;
import litll.idl.std.data.idl.project.DelitllfierOutputConfig;
import litll.idl.std.data.idl.project.OutputConfig;
import litll.idl.std.data.idl.project.ProjectConfig;
import litll.idl.std.data.idl.project.SourceConfig;
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
				Option.Some(
					new DelitllfierOutputConfig(
						[
							TypeGroupPath.create("litll").getOrThrow(),
						],
						[]
					)
				)
			)
		);
		
		IdlProject.run(
			"../../../../../data/idl", 
			config
		);
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
