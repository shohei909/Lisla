package sora.project.generator;

import haxe.ds.Option;
import sora.project.idl.IdlProject;
import sora.idl.data.idl.project.ProjectConfig;
import sora.idl.data.idl.project.OutputConfig;
import sora.idl.data.idl.project.DesoralizerOutputConfig;
import sora.idl.data.idl.project.SourceConfig;

class Main 
{
	public static function main():Void
	{
		var config = new ProjectConfig(
			new SourceConfig([], []),
			new OutputConfig(
				"../../generated",
				["sora"],
				[
					IdlRenameFilter.Prefix("sora", "sora.idl.data")
				],
				Option.Some(
					new DesoralizerOutputConfig(
						["sora"],
						[
							IdlRenameFilter.Prefix("sora", "sora.idl.desoralizer")
						]
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
