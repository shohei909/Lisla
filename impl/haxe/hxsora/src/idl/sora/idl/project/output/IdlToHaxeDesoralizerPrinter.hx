package sora.idl.project.output;
import sora.core.ds.Result;
import sora.idl.project.output.IdlToHaxePrintContext;
import sora.idl.project.output.path.HaxeDesoralizerTypePathPair;
import sora.idl.std.data.idl.TypePath;
import sora.idl.std.data.idl.project.DataOutputConfig;
import sora.idl.project.source.IdlSourceProviderImpl;
import sora.idl.std.data.idl.project.DesoralizerOutputConfig;

class IdlToHaxeDesoralizerPrinter
{
	public static function print(context:IdlToHaxePrintContext, config:DesoralizerOutputConfig) :Void
	{
		var types = switch (context.source.resolveGroups(config.targets))
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
		
		for (typePath in types.keys())
		{
			var pathPair = HaxeDesoralizerTypePathPair.create(typePath, context.dataOutputConfig, config);
			var convertedType = IdlToHaxeDesoralizerConverter.convertType(pathPair, types[typePath], context, config);
			context.printer.printType(convertedType);
		}
	}
}
