package litll.idl.generator;
import litll.idl.ds.ProcessResult;
import litll.idl.generator.io.StandardIoProvider;
import litll.idl.generator.output.IdlToHaxePrintContext;
import litll.idl.generator.data.ProjectConfig;
import litll.idl.generator.output.IdlToHaxePrinter;
import litll.idl.generator.source.IdlSourceProviderImpl;

class IdlProject
{
	public static function run(homeDirectory:String, config:ProjectConfig):ProcessResult
	{
		var context = IdlToHaxePrintContext.createDefault(homeDirectory, config);
		return IdlToHaxePrinter.run(context);
	}
}
