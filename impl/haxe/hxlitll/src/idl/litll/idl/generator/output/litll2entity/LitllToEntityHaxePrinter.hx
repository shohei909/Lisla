package litll.idl.generator.output.litll2entity;
import hxext.ds.Result;
import litll.idl.ds.ProcessResult;
import litll.idl.generator.output.IdlToHaxePrintContext;
import litll.idl.generator.output.litll2entity.convert.LitllToEntityHaxeGenerator;
import litll.idl.generator.output.litll2entity.path.HaxeLitllToEntityTypePathPair;
import litll.idl.std.data.idl.TypePath;
import litll.idl.generator.data.LitllToEntityOutputConfig;
using hxext.ds.ResultTools;

class LitllToEntityHaxePrinter
{
	public static function print(context:IdlToHaxePrintContext, config:LitllToEntityOutputConfig):ProcessResult
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
            var pathPair = new HaxeLitllToEntityTypePathPair(
                type,
                config.toHaxeLitllToEntityPath(type.typePath)
            );
			var convertedType = LitllToEntityHaxeGenerator.convertType(pathPair, context, config);
			context.printer.printType(convertedType);
		}
		
		return ProcessResult.Success;
	}
}
