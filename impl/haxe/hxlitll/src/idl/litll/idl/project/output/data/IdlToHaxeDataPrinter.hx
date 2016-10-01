package litll.idl.project.output.data;

import litll.core.ds.Result;
import litll.idl.ds.ProcessResult;
import litll.idl.project.output.IdlToHaxePrintContext;
import litll.idl.project.output.data.IdlToHaxeDataConverter;
import litll.idl.project.output.data.HaxeDataTypePath;
import litll.idl.std.data.idl.TypePath;
using litll.core.ds.ResultTools;

class IdlToHaxeDataPrinter
{
	public static function run(context:IdlToHaxePrintContext):ProcessResult
	{
		recordPredefinedTypes(context);
		return print(context);
	}

	private static function recordPredefinedTypes(context:IdlToHaxePrintContext):Void
	{
		var predefinedTypes = context.dataOutputConfig.predefinedTypes;
		for (type in predefinedTypes)
		{
			context.interfaceStore.add(type.path, type);
		}
	}
	
	private static function print(context:IdlToHaxePrintContext):ProcessResult
	{
		var targets = context.dataOutputConfig.targets;
		var types = switch (context.source.resolveGroups(targets))
		{
			case Result.Ok(_types):
				_types;
				
			case Result.Err(errors):
				for (error in errors)
				{
					Sys.stderr().writeString("Error: " + error.toString() + "\n");
				}
				return ProcessResult.Failure;
		}
		
		for (typePath in types.keys())
		{
			var config = context.dataOutputConfig;
			var convertedPath = config.toHaxeDataPath(typePath);
			if (context.interfaceStore.exists(convertedPath))
			{
				continue;
			}
			
			var convertedType = IdlToHaxeDataConverter.convertType(convertedPath, types[typePath], config);
			context.printer.printType(convertedType);
		}
		
		return ProcessResult.Success;
	}
}
