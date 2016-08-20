package sora.idl.std.desoralize.idl;
import haxe.ds.Option;
import sora.idl.desoralize.DesoralizeContext;
import sora.idl.desoralize.DesoralizeError;
import sora.idl.desoralize.DesoralizeUnionContext;
import sora.core.ds.Result;
import sora.idl.std.data.idl.TypeNameDeclaration;
using sora.core.ds.ResultTools;

class TypeNameDeclarationDesoralizer
{
	public static function process(context:DesoralizeContext):Result<TypeNameDeclaration, DesoralizeError> 
	{
		return try
		{
			var unionContext = new DesoralizeUnionContext(context);
			switch (unionContext.read(TypeNameDesoralizer.process).getOrThrow())
			{
				case Option.Some(data):
					return Result.Ok(TypeNameDeclaration.Primitive(data));
					
				case Option.None:
			}
			switch (unionContext.read(GenericTypeNameDesoralizer.process).getOrThrow())
			{
				case Option.Some(data):
					return Result.Ok(TypeNameDeclaration.Generic(data));
					
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
