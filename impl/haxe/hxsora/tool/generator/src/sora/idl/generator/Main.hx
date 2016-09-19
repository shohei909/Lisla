package sora.idl.generator;

import haxe.ds.Option;
import haxe.io.Path;
import sora.idl.project.IdlProject;
import sora.idl.std.data.idl.path.TypeGroupPath;
import sora.idl.std.data.idl.project.DataOutputConfig;
import sora.idl.std.data.idl.project.DesoralizerOutputConfig;
import sora.idl.std.data.idl.project.OutputConfig;
import sora.idl.std.data.idl.project.ProjectConfig;
import sora.idl.std.data.idl.project.SourceConfig;
import sys.FileSystem;
using sora.core.ds.ResultTools;
class Main 
{
	public static function main():Void
	{
		remove("../../migration/sora");
		
		var config = new ProjectConfig(
			new SourceConfig([], []),
			new OutputConfig(
				"../../migration",
				new DataOutputConfig(
					[
						TypeGroupPath.create("sora").getOrThrow(),
					],
					[]
				),
				Option.Some(
					new DesoralizerOutputConfig(
						[
							TypeGroupPath.create("sora").getOrThrow(),
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
