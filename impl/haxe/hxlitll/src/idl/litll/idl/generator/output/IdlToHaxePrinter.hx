package litll.idl.generator.output;
import haxe.ds.Option;
import litll.idl.ds.ProcessResult;
import litll.idl.generator.output.IdlToHaxePrintContext;
import litll.idl.generator.output.data.IdlToHaxeDataPrinter;
import litll.idl.generator.output.delitll.IdlToHaxeLitllToBackendPrinter;

class IdlToHaxePrinter
{
	public static function run(context:IdlToHaxePrintContext):ProcessResult
	{
		if (IdlToHaxeDataPrinter.run(context)) return ProcessResult.Failure;
		
		switch (context.litllToBackendOutputConfig.toOption())
		{
			case Option.Some(litllToBackendOutputConfig):
				if (IdlToHaxeLitllToBackendPrinter.print(context, litllToBackendOutputConfig)) return ProcessResult.Failure;
				
			case Option.None:
				// nothing to do...
		}
		
		return ProcessResult.Success;
	}
}
