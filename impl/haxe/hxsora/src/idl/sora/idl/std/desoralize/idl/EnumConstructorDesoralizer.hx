package sora.idl.std.desoralize.idl;
import haxe.ds.Option;
import sora.idl.desoralize.DesoralizeContext;
import sora.idl.desoralize.DesoralizeError;
import sora.idl.desoralize.DesoralizeUnionContext;
import sora.core.ds.Result;
import sora.idl.std.data.idl.EnumConstructor;
import sora.idl.std.data.idl.TypeReference;
using sora.core.ds.ResultTools;

class EnumConstructorDesoralizer
{
	
	public static function process(context:DesoralizeContext):Result<EnumConstructor, DesoralizeError> 
	{
		return try
		{
			var unionContext = new DesoralizeUnionContext(context);
			switch (unionContext.read(EnumConstructorNameDesoralizer.process).getOrThrow())
			{
				case Option.Some(data):
					return Result.Ok(EnumConstructor.Primitive(data));
					
				case Option.None:
			}
			switch (unionContext.read(ParameterizedEnumConstructorDesoralizer.process).getOrThrow())
			{
				case Option.Some(data):
					return Result.Ok(EnumConstructor.Parameterized(data));
					
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
