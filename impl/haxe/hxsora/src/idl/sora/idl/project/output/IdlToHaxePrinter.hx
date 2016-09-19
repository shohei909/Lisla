package sora.idl.project.output;
import haxe.ds.Option;
import sora.idl.project.IdlToHaxePrintContext;
import sora.idl.project.io.IoProvider;
import sora.idl.project.source.IdlSourceProviderImpl;
import sora.idl.std.data.idl.project.OutputConfig;

class IdlToHaxePrinter
{
	public static function run(context:IdlToHaxePrintContext):Void
	{
		IdlToHaxeDataPrinter.run(context);
		
		switch (context.desoralizerOutputConfig)
		{
			case Option.Some(desoralizerOutputConfig):
				IdlToHaxeDesoralizerPrinter.print(context, desoralizerOutputConfig);
				
			case Option.None:
				// nothing to do...
		}
	}
}
