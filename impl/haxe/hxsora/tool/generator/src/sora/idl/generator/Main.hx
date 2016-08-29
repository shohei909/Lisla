package sora.idl.generator;

import haxe.ds.Option;
import sora.idl.project.IdlProject;
import sora.idl.std.data.idl.path.TypeGroupPath;
import sora.idl.std.data.idl.project.DataOutputConfig;
import sora.idl.std.data.idl.project.DesoralizerOutputConfig;
import sora.idl.std.data.idl.project.OutputConfig;
import sora.idl.std.data.idl.project.ProjectConfig;
import sora.idl.std.data.idl.project.SourceConfig;
using sora.core.ds.ResultTools;
class Main 
{
	public static function main():Void
	{
		var config = new ProjectConfig(
			new SourceConfig([], []),
			new OutputConfig(
				"../../generated",
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
}
