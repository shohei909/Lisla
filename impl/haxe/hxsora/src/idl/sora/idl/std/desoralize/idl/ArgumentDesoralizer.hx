package sora.idl.std.desoralize.idl;
import haxe.ds.Option;
import sora.core.Sora;
import sora.core.SoraArray;
import sora.idl.desoralize.DesoralizeArrayContext;
import sora.idl.desoralize.DesoralizeContext;
import sora.idl.desoralize.DesoralizeError;
import sora.idl.desoralize.DesoralizeErrorKind;
import sora.idl.desoralize.Desoralizer;
import sora.core.ds.Result;
import sora.idl.std.data.idl.Argument;
import sora.idl.std.data.core.SoraOption;
import sora.idl.std.data.core.Unit;
import sora.idl.std.desoralize.idl.TypeReferenceDesoralizer;
import sora.idl.std.desoralize.core.OptionDesoralizer;
using sora.core.ds.ResultTools;

class ArgumentDesoralizer
{
	public static function process(context:DesoralizeContext):Result<Argument, DesoralizeError> 
	{
		return switch (context.sora)
		{
			case Sora.Str(string):
				Result.Err(DesoralizeError.ofString(string, Option.None, DesoralizeErrorKind.CantBeString));
				
			case Sora.Arr(array):
				try
				{
					var arrayContext = new DesoralizeArrayContext(context, array, 0);
					var name = arrayContext.read(ArgumentNameDesoralizer.process).getOrThrow();
					var parameters = arrayContext.read(TypeReferenceDesoralizer.process).getOrThrow();
					var defaultValue = arrayContext.readWithDefault(
						OptionDesoralizer.process.bind(Desoralizer.processSora), 
						SoraOption.None(new Unit())
					).getOrThrow();
					arrayContext.close(Argument.new.bind(name, parameters, defaultValue));
				}
				catch (error:DesoralizeError)
				{
					Result.Err(error);
				}
		}
	}
}
