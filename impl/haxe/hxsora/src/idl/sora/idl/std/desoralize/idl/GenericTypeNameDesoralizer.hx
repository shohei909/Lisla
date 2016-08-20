package sora.idl.std.desoralize.idl;
import haxe.ds.Option;
import sora.core.Sora;
import sora.idl.desoralize.DesoralizeArrayContext;
import sora.idl.desoralize.DesoralizeContext;
import sora.idl.desoralize.DesoralizeError;
import sora.idl.desoralize.DesoralizeErrorKind;
import sora.core.ds.Result;
import sora.idl.std.data.idl.GenericTypeName;
using sora.core.ds.ResultTools;

class GenericTypeNameDesoralizer
{
	public static function process(context:DesoralizeContext):Result<GenericTypeName, DesoralizeError> 
	{
		return switch (context.sora)
		{
			case Sora.Str(string):
				Result.Err(DesoralizeError.ofString(string, Option.None, DesoralizeErrorKind.CantBeString));
				
			case Sora.Arr(array):
				try
				{
					var arrayContext = new DesoralizeArrayContext(context, array, 0);
					var name = arrayContext.read(TypeNameDesoralizer.process).getOrThrow();
					var parameters = arrayContext.readRest(TypeParameterDeclarationDesoralizer.process).getOrThrow();
					arrayContext.close(GenericTypeName.new.bind(name, parameters));
				}
				catch (error:DesoralizeError)
				{
					Result.Err(error);
				}
		}
	}
}