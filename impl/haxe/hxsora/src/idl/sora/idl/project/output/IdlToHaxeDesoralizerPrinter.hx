package sora.idl.project.output;
import sora.core.ds.Result;
import sora.idl.project.IdlToHaxePrintContext;
import sora.idl.std.data.idl.project.DataOutputConfig;
import sora.idl.project.source.IdlSourceProviderImpl;
import sora.idl.std.data.idl.project.DesoralizerOutputConfig;

class IdlToHaxeDesoralizerPrinter
{
	public static function print(context:IdlToHaxePrintContext, desoralizerConfig:DesoralizerOutputConfig) :Void
	{
		var types = switch (context.source.resolveGroups(desoralizerConfig.targets))
		{
			case Result.Ok(_types):
				_types;
				
			case Result.Err(errors):
				for (error in errors)
				{
					Sys.println(error.toString());
				}
				return;
		}
		
		for (typeName in types.keys())
		{
			
		}
	}
}
