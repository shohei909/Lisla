package litll.idl.generator.output.data;

import litll.core.ds.Result;
import litll.idl.ds.ProcessResult;
import litll.idl.generator.output.IdlToHaxePrintContext;
import litll.idl.generator.output.data.IdlToHaxeDataConverter;
import litll.idl.generator.output.data.HaxeDataTypePath;
import litll.idl.generator.output.data.store.HaxeDataClassInterface;
import litll.idl.generator.output.data.store.HaxeDataConstructorKind;
import litll.idl.generator.output.data.store.HaxeDataInterface;
import litll.idl.generator.output.data.store.HaxeDataInterfaceKind;
import litll.idl.std.data.idl.TypePath;
using litll.core.ds.ResultTools;

class IdlToHaxeDataPrinter
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
					context.io.printErrorLine(error.toString());
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
            
            var convertedType = IdlToHaxeDataConverter.convertType(type, config);
			context.printer.printType(convertedType);
		}
		
		return ProcessResult.Success;
	}
}
