package litll.idl.generator.output.delitll;
import litll.core.ds.Result;
import litll.idl.ds.ProcessResult;
import litll.idl.generator.output.IdlToHaxePrintContext;
import litll.idl.generator.output.delitll.convert.IdlToHaxeLitllToBackendConverter;
import litll.idl.generator.output.delitll.path.HaxeLitllToBackendTypePathPair;
import litll.idl.std.data.idl.TypePath;
import litll.idl.generator.data.LitllToBackendOutputConfig;
using litll.core.ds.ResultTools;

class IdlToHaxeLitllToBackendPrinter
{
	public static function print(context:IdlToHaxePrintContext, config:LitllToBackendOutputConfig):ProcessResult
	{
		var types = switch (context.resolveGroups(config.targets))
		{
			case Result.Ok(_types):
				_types;
				
			case Result.Err(errors):
				for (error in errors)
				{
					context.io.printErrorLine(error.getSummary().toString());
				}
				return ProcessResult.Failure;
		}
		
		for (type in types)
		{
            var pathPair = new HaxeLitllToBackendTypePathPair(
                type,
                config.toHaxeLitllToBackendPath(type.typePath)
            );
			var convertedType = IdlToHaxeLitllToBackendConverter.convertType(pathPair, context, config);
			context.printer.printType(convertedType);
		}
		
		return ProcessResult.Success;
	}
}
