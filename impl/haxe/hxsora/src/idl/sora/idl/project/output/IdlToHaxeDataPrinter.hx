package sora.idl.project.output;

import sora.core.ds.Result;
import sora.idl.project.IdlToHaxePrintContext;
import sora.idl.std.data.idl.TypePath;
using sora.core.ds.ResultTools;

class IdlToHaxeDataPrinter
{
	public static function run(context:IdlToHaxePrintContext):Void
	{
		recordPredefinedTypes(context);
		print(context);
	}

	private static function recordPredefinedTypes(context:IdlToHaxePrintContext):Void
	{
		var predefinedTypes = context.dataOutputConfig.predefinedTypes;
		for (key in predefinedTypes.keys())
		{
			var path = TypePath.create(key);
			context.interfaceRecord.add(path.getOrThrow(), predefinedTypes[key]);
		}
	}
	
	private static function print(context:IdlToHaxePrintContext):Void
	{
		var targets = context.dataOutputConfig.targets;
		trace(targets);
		var types = switch (context.source.resolveGroups(targets))
		{
			case Result.Ok(_types):
				_types;
				
			case Result.Err(errors):
				for (error in errors)
				{
					Sys.stderr().writeString(error.toString() + "\n");
				}
				return;
		}
		
		for (typePath in types.keys())
		{
			var config = context.dataOutputConfig;
			var convertedPath:TypePath = config.applyFilters(typePath);
			if (context.interfaceRecord.exists(convertedPath))
			{
				continue;
			}
			
			// context.interfaceRecord.add(convertedPath, );
			
			var convertedType = IdlToHaxeDataConverter.convertType(typePath, types[typePath], config);
			
			context.printer.printType(convertedType);
		}
	}
}
