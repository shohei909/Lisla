package sora.idl.std.desoralize;
import sora.core.Sora;
import sora.core.SoraArray;
import sora.core.ds.Result;
import sora.idl.desoralize.DesoralizeContext;
import sora.idl.desoralize.DesoralizeError;
import sora.idl.desoralize.DesoralizeErrorKind;

class ArrayDesoralizer
{
	public function process(context:DesoralizeContext):Result<SoraArray, DesoralizeError> 
	{
		return switch (context.sora)
		{
			case Sora.Str(string):
				Result.Err(DesoralizeError.ofSora(context.sora, DesoralizeErrorKind.CantBeString));
				
			case Sora.Arr(array):
				Result.Ok(array);
		}
	}
}
