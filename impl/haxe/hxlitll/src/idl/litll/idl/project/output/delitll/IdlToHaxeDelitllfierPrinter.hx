package litll.idl.project.output.delitll;
import litll.core.ds.Result;
import litll.idl.ds.ProcessResult;
import litll.idl.project.output.IdlToHaxePrintContext;
import litll.idl.project.output.delitll.HaxeDelitllfierTypePathPair;
import litll.idl.std.data.idl.haxe.DelitllfierOutputConfig;

class IdlToHaxeDelitllfierPrinter
{
	public static function print(context:IdlToHaxePrintContext, config:DelitllfierOutputConfig):ProcessResult
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
				return ProcessResult.Failure;
		}
		
		for (typePath in types.keys())
		{
			var pathPair = HaxeDelitllfierTypePathPair.create(typePath, context.dataOutputConfig, config);
			var convertedType = IdlToHaxeDelitllfierConverter.convertType(pathPair, types[typePath], context, config);
			context.printer.printType(convertedType);
		}
		
		return ProcessResult.Success;
	}
}
