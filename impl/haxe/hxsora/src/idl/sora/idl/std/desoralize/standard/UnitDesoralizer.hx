package sora.idl.std.desoralize.standard;
import haxe.ds.Option;
import sora.core.Sora;
import sora.idl.desoralize.DesoralizeArrayContext;
import sora.idl.desoralize.DesoralizeContext;
import sora.idl.desoralize.DesoralizeError;
import sora.idl.desoralize.DesoralizeErrorKind;
import sora.core.ds.Result;
import sora.idl.std.data.core.Unit;

class UnitDesoralizer
{
	public static function process(context:DesoralizeContext):Result<Unit, DesoralizeError>
	{
		return switch (context.sora)
		{
			case Sora.Str(string):
				Result.Err(DesoralizeError.ofString(string, Option.None, DesoralizeErrorKind.CantBeString));
				
			case Sora.Arr(array):
				try
				{
					var arrayContext = new DesoralizeArrayContext(context, array, 0);
					arrayContext.close(Unit.new);
				}
				catch (error:DesoralizeError)
				{
					Result.Err(error);
				}
		}
	}	
}
