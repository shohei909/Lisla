package litll.idl.generator.output;
import haxe.ds.Option;
import litll.idl.ds.ProcessResult;
import litll.idl.generator.output.IdlToHaxePrintContext;
import litll.idl.generator.output.data.IdlToHaxeDataPrinter;
import litll.idl.generator.output.delitll.IdlToHaxeDelitllfierPrinter;

class IdlToHaxePrinter
{
	public static function run(context:IdlToHaxePrintContext):ProcessResult
	{
		if (IdlToHaxeDataPrinter.run(context)) return ProcessResult.Failure;
		
		switch (context.delitllfierOutputConfig.toOption())
		{
			case Option.Some(delitllfierOutputConfig):
				if (IdlToHaxeDelitllfierPrinter.print(context, delitllfierOutputConfig)) return ProcessResult.Failure;
				
			case Option.None:
				// nothing to do...
		}
		
		return ProcessResult.Success;
	}
}
