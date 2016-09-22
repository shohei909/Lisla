package sora.idl.project;
import sora.idl.project.io.StandardIoProvider;
import sora.idl.project.output.IdlToHaxePrintContext;
import sora.idl.std.data.idl.project.ProjectConfig;
import sora.idl.project.output.IdlToHaxePrinter;
import sora.idl.project.source.IdlSourceProviderImpl;

class IdlProject
{
	public static function run(homeDirectory:String, config:ProjectConfig):Void
	{
		var context = IdlToHaxePrintContext.createDefault(homeDirectory, config);
		IdlToHaxePrinter.run(context);
	}
}
