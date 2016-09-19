package sora.idl.std.desoralize.idl;
import haxe.ds.Option;
import sora.core.Sora;
import sora.idl.desoralize.DesoralizeArrayContext;
import sora.idl.desoralize.DesoralizeContext;
import sora.idl.desoralize.DesoralizeError;
import sora.idl.desoralize.DesoralizeErrorKind;
import sora.core.ds.Result;
import sora.idl.std.data.idl.ParameterizedEnumConstructor;
using sora.core.ds.ResultTools;

class ParameterizedEnumConstructorDesoralizer
{
	public static function process(context:DesoralizeContext):Result<ParameterizedEnumConstructor, DesoralizeError> 
	{
		return switch (context.sora)
		{
			case Sora.Str(string):
				Result.Err(DesoralizeError.ofString(string, Option.None, DesoralizeErrorKind.CantBeString));
				
			case Sora.Arr(array):
				try
				{
					var arrayContext = new DesoralizeArrayContext(context, array, 0);
					var name = arrayContext.read(EnumConstructorNameDesoralizer.process).getOrThrow();
					var arguments = arrayContext.readRest(ArgumentDesoralizer.process).getOrThrow();
					arrayContext.close(ParameterizedEnumConstructor.new.bind(name, arguments));
				}
				catch (error:DesoralizeError)
				{
					Result.Err(error);
				}
		}
	}
}
