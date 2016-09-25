package litll.idl.project.output;
import litll.core.ds.Result;
import litll.idl.project.output.IdlToHaxePrintContext;
import litll.idl.project.output.path.HaxeLitllfierTypePathPair;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.project.DataOutputConfig;
import litll.idl.project.source.IdlSourceProviderImpl;
import litll.idl.std.data.idl.project.LitllfierOutputConfig;

class IdlToHaxeLitllfierPrinter
{
	public static function print(context:IdlToHaxePrintContext, config:LitllfierOutputConfig) :Void
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
			var pathPair = HaxeLitllfierTypePathPair.create(typePath, context.dataOutputConfig, config);
			var convertedType = IdlToHaxeLitllfierConverter.convertType(pathPair, types[typePath], context, config);
			context.printer.printType(convertedType);
		}
	}
}
