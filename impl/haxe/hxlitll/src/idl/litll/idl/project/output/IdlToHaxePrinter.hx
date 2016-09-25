package litll.idl.project.output;
import haxe.ds.Option;
import litll.idl.project.output.IdlToHaxePrintContext;
import litll.idl.project.io.IoProvider;
import litll.idl.project.source.IdlSourceProviderImpl;
import litll.idl.std.data.idl.project.OutputConfig;

class IdlToHaxePrinter
{
	public static function run(context:IdlToHaxePrintContext):Void
	{
		IdlToHaxeDataPrinter.run(context);
		
		switch (context.delitllfierOutputConfig)
		{
			case Option.Some(delitllfierOutputConfig):
				IdlToHaxeDelitllfierPrinter.print(context, delitllfierOutputConfig);
				
			case Option.None:
				// nothing to do...
		}
	}
}
