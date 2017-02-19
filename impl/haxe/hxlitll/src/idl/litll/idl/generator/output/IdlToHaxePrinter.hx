package litll.idl.generator.output;
import haxe.ds.Option;
import litll.idl.ds.ProcessResult;
import litll.idl.generator.output.IdlToHaxePrintContext;
import litll.idl.generator.output.entity.EntityHaxePrinter;
import litll.idl.generator.output.litll2entity.LitllToEntityHaxePrinter;

class IdlToHaxePrinter
{
	public static function run(context:IdlToHaxePrintContext):ProcessResult
	{
		if (EntityHaxePrinter.run(context)) return ProcessResult.Failure;
		
		switch (context.litllToEntityOutputConfig.toOption())
		{
			case Option.Some(litllToEntityOutputConfig):
				if (LitllToEntityHaxePrinter.print(context, litllToEntityOutputConfig)) return ProcessResult.Failure;
				
			case Option.None:
				// nothing to do...
		}
		
		return ProcessResult.Success;
	}
}
