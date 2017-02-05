package litll.idl.generator;
import litll.idl.ds.ProcessResult;
import litll.idl.generator.data.ProjectConfig;
import litll.idl.generator.output.IdlToHaxePrintContext;
import litll.idl.generator.output.IdlToHaxePrinter;

class IdlProject
{
	public static function run(homeDirectory:String, config:ProjectConfig):ProcessResult
	{
		var context = IdlToHaxePrintContext.createDefault(homeDirectory, config);
		return IdlToHaxePrinter.run(context);
	}
}
