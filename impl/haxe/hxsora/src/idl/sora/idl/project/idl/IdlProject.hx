package sora.idl.project.idl;
import sora.idl.std.data.idl.project.ProjectConfig;
import sora.idl.project.idl.output.IdlOutputRunner;
import sora.idl.project.idl.source.IdlSourceProvider;

class IdlProject
{
	public static function run(homeDirectory:String, config:ProjectConfig):Void
	{
		var provider = new IdlSourceProvider(homeDirectory, config.sourceConfig);
		var outputRunner = IdlOutputRunner.run(provider, config.outputConfig);
	}
}
