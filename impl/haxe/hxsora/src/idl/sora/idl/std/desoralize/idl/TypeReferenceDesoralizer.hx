package sora.idl.std.desoralize.idl;
import haxe.ds.Option;
import sora.idl.desoralize.DesoralizeContext;
import sora.idl.desoralize.DesoralizeError;
import sora.idl.desoralize.DesoralizeUnionContext;
import sora.core.ds.Result;
import sora.idl.std.data.idl.TypeReference;
import sora.idl.std.desoralize.idl.GenericTypeReferenceDesoralizer;
import sora.idl.std.desoralize.idl.TypePathDesoralizer;
using sora.core.ds.ResultTools;

class TypeReferenceDesoralizer
{
	public static function process(context:DesoralizeContext):Result<TypeReference, DesoralizeError> 
	{
		return try
		{
			var unionContext = new DesoralizeUnionContext(context);
			switch (unionContext.read(TypePathDesoralizer.process).getOrThrow())
			{
				case Option.Some(data):
					return Result.Ok(TypeReference.Primitive(data));
					
				case Option.None:
			}
			switch (unionContext.read(GenericTypeReferenceDesoralizer.process).getOrThrow())
			{
				case Option.Some(data):
					return Result.Ok(TypeReference.Generic(data));
					
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
