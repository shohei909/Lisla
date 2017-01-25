package litll.idl.project.output.delitll;
import litll.core.ds.Result;
import litll.idl.ds.ProcessResult;
import litll.idl.project.output.IdlToHaxePrintContext;
import litll.idl.project.output.delitll.HaxeDelitllfierTypePathPair;
import litll.idl.std.data.idl.TypePath;
import litll.idl.project.data.DelitllfierOutputConfig;
using litll.core.ds.ResultTools;

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
					context.io.printErrorLine(error.toString());
				}
				return ProcessResult.Failure;
		}
		
		for (key in types.keys())
		{
            var typePath = TypePath.create(key).getOrThrow();
			var pathPair = HaxeDelitllfierTypePathPair.create(typePath, context.dataOutputConfig, config);
			var convertedType = IdlToHaxeDelitllfierConverter.convertType(pathPair, types[key], context, config);
			context.printer.printType(convertedType);
		}
		
		return ProcessResult.Success;
	}
}
