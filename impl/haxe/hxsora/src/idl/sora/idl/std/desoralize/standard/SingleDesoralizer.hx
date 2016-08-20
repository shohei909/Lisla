package sora.idl.std.desoralize.standard;
import haxe.ds.Option;
import sora.core.Sora;
import sora.idl.desoralize.DesoralizeArrayContext;
import sora.idl.desoralize.DesoralizeContext;
import sora.idl.desoralize.DesoralizeError;
import sora.idl.desoralize.DesoralizeErrorKind;
import sora.core.ds.Result;
import sora.idl.std.data.core.SoraSingle;
using sora.core.ds.ResultTools;

class SingleDesoralizer
{
	public static function process<T>(tProcess:DesoralizeContext->Result<T, DesoralizeError>, context:DesoralizeContext):Result<SoraSingle<T>, DesoralizeError> 	
	{
		return switch (context.sora)
		{
			case Sora.Str(string):
				Result.Err(DesoralizeError.ofString(string, Option.None, DesoralizeErrorKind.CantBeString));
				
			case Sora.Arr(array):
				try
				{
					var arrayContext = new DesoralizeArrayContext(context, array, 0);
					var element1 = arrayContext.read(tProcess).getOrThrow();
					arrayContext.close(SoraSingle.new.bind(element1));
				}
				catch (error:DesoralizeError)
				{
					Result.Err(error);
				}
		}
	}
}