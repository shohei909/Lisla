package litll.idl.project.output;
import haxe.ds.Option;
import litll.idl.ds.ProcessResult;
import litll.idl.project.output.IdlToHaxePrintContext;
import litll.idl.project.output.data.IdlToHaxeDataPrinter;
import litll.idl.project.output.delitll.IdlToHaxeDelitllfierPrinter;

class IdlToHaxePrinter
{
	public static function run(context:IdlToHaxePrintContext):ProcessResult
	{
		if (IdlToHaxeDataPrinter.run(context)) return ProcessResult.Failure;
		
		switch (context.delitllfierOutputConfig)
		{
			case Option.Some(delitllfierOutputConfig):
				if (IdlToHaxeDelitllfierPrinter.print(context, delitllfierOutputConfig)) return ProcessResult.Failure;
				
			case Option.None:
				// nothing to do...
		}
		
		return ProcessResult.Success;
	}
}
