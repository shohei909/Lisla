package litll.idl.generator.output.delitll;
import litll.core.ds.Result;
import litll.idl.ds.ProcessResult;
import litll.idl.generator.output.IdlToHaxePrintContext;
import litll.idl.generator.output.delitll.convert.IdlToHaxeDelitllfierConverter;
import litll.idl.generator.output.delitll.path.HaxeDelitllfierTypePathPair;
import litll.idl.std.data.idl.TypePath;
import litll.idl.generator.data.DelitllfierOutputConfig;
using litll.core.ds.ResultTools;

class IdlToHaxeDelitllfierPrinter
{
	public static function print(context:IdlToHaxePrintContext, config:DelitllfierOutputConfig):ProcessResult
	{
		var types = switch (context.resolveGroups(config.targets))
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
		
		for (type in types)
		{
            var pathPair = new HaxeDelitllfierTypePathPair(
                type,
                config.toHaxeDelitllfierPath(type.typePath)
            );
			var convertedType = IdlToHaxeDelitllfierConverter.convertType(pathPair, context, config);
			context.printer.printType(convertedType);
		}
		
		return ProcessResult.Success;
	}
}
