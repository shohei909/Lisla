package litll.idl.project;
import litll.idl.ds.ProcessResult;
import litll.idl.project.io.StandardIoProvider;
import litll.idl.project.output.IdlToHaxePrintContext;
import litll.idl.project.data.ProjectConfig;
import litll.idl.project.output.IdlToHaxePrinter;
import litll.idl.project.source.IdlSourceProviderImpl;

class IdlProject
{
	public static function run(homeDirectory:String, config:ProjectConfig):ProcessResult
	{
		var context = IdlToHaxePrintContext.createDefault(homeDirectory, config);
		return IdlToHaxePrinter.run(context);
	}
}
