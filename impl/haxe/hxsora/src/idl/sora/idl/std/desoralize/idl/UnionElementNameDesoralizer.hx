package sora.idl.std.desoralize.idl;
import sora.core.Sora;
import sora.idl.desoralize.DesoralizeContext;
import sora.idl.desoralize.DesoralizeError;
import sora.idl.desoralize.DesoralizeErrorKind;
import sora.core.ds.Result;
import sora.idl.std.data.idl.EnumConstructorName;
import sora.idl.std.data.idl.UnionElementName;

class UnionElementNameDesoralizer
{
	public static function process(context:DesoralizeContext):Result<UnionElementName, DesoralizeError> 	
	{
		return switch (context.sora)
		{
			case Sora.Str(string):
				Result.Ok(new UnionElementName(string.data));
			
			case Sora.Arr(array):
				Result.Err(DesoralizeError.ofSora(context.sora, DesoralizeErrorKind.CantBeArray));
		}
	}	
}
