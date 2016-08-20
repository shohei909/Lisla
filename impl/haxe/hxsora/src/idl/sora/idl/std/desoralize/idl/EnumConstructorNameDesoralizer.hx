package sora.idl.std.desoralize.idl;
import sora.core.Sora;
import sora.idl.desoralize.DesoralizeContext;
import sora.idl.desoralize.DesoralizeError;
import sora.idl.desoralize.DesoralizeErrorKind;
import sora.core.ds.Result;
import sora.idl.std.data.idl.EnumConstructorName;

class EnumConstructorNameDesoralizer
{
	public static function process(context:DesoralizeContext):Result<EnumConstructorName, DesoralizeError> 	
	{
		return switch (context.sora)
		{
			case Sora.Str(string):
				Result.Ok(new EnumConstructorName(string.data));
			
			case Sora.Arr(array):
				Result.Err(DesoralizeError.ofSora(context.sora, DesoralizeErrorKind.CantBeArray));
		}
	}
}
