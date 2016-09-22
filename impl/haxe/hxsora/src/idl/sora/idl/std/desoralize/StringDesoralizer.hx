package sora.idl.std.desoralize;
import sora.core.Sora;
import sora.core.SoraString;
import sora.core.ds.Result;
import sora.idl.desoralize.DesoralizeContext;
import sora.idl.desoralize.DesoralizeError;
import sora.idl.desoralize.DesoralizeErrorKind;

class StringDesoralizer
{
	public static inline function process(context:DesoralizeContext):Result<SoraString, DesoralizeError> 
	{
		return switch (context.sora)
		{
			case Sora.Str(string):
				Result.Ok(string);
				
			case Sora.Arr(array):
				Result.Err(DesoralizeError.ofSora(context.sora, DesoralizeErrorKind.CantBeArray));
		}
	}
}
