package litll.idl.project;
import litll.idl.project.io.StandardIoProvider;
import litll.idl.project.output.IdlToHaxePrintContext;
import litll.idl.std.data.idl.haxe.ProjectConfig;
import litll.idl.project.output.IdlToHaxePrinter;
import litll.idl.project.source.IdlSourceProviderImpl;

class IdlProject
{
	public static function run(homeDirectory:String, config:ProjectConfig):Void
	{
		var context = IdlToHaxePrintContext.createDefault(homeDirectory, config);
		IdlToHaxePrinter.run(context);
	}
}
