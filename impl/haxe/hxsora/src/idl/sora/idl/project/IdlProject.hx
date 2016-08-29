package sora.idl.project;
import sora.idl.std.data.idl.project.ProjectConfig;
import sora.idl.project.output.IdlOutputRunner;
import sora.idl.project.source.IdlSourceProvider;

class IdlProject
{
	public static function run(homeDirectory:String, config:ProjectConfig):Void
	{
		var provider = new IdlSourceProvider(homeDirectory, config.sourceConfig);
		IdlOutputRunner.run(provider, config.outputConfig);
	}
}
