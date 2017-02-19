package litll.idl.generator.output.entity;

import hxext.ds.Result;
import litll.idl.ds.ProcessResult;
import litll.idl.generator.output.IdlToHaxePrintContext;
import litll.idl.generator.output.entity.EntityHaxeGenerator;
using hxext.ds.ResultTools;

class EntityHaxePrinter
{
	public static function run(context:IdlToHaxePrintContext):ProcessResult
	{
		var targets = context.dataOutputConfig.targets;
		var types = switch (context.resolveGroups(targets))
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
			var config = context.dataOutputConfig;
            if (config.predefinedTypes.exists(type.haxePath.toString()))
            {
                continue;
            }
            
            var convertedType = EntityHaxeGenerator.convertType(type, config);
			context.printer.printType(convertedType);
		}
		
		return ProcessResult.Success;
	}
}
