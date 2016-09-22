package sora.idl.std.desoralize.core;
import haxe.ds.Option;
import sora.idl.desoralize.DesoralizeContext;
import sora.idl.desoralize.DesoralizeError;
import sora.idl.desoralize.DesoralizeUnionContext;
import sora.core.ds.Result;
import sora.idl.std.data.core.SoraOption;
using sora.core.ds.ResultTools;

class OptionDesoralizer
{
	public static function process<T>(tProcess:DesoralizeContext->Result<T, DesoralizeError>, context:DesoralizeContext):Result<SoraOption<T>, DesoralizeError> 
	{
		return try
		{
			var unionContext = new DesoralizeUnionContext(context);
			switch (unionContext.read(UnitDesoralizer.process).getOrThrow())
			{
				case Option.Some(data):
					return Result.Ok(SoraOption.None(data));
					
				case Option.None:
			}
			switch (unionContext.read(SingleDesoralizer.process.bind(tProcess)).getOrThrow())
			{
				case Option.Some(data):
					return Result.Ok(SoraOption.Some(data));
					
				case Option.None:
			}
			unionContext.close();
		}
		catch (e:DesoralizeError)
		{
			Result.Err(e);
		}
	}
}
