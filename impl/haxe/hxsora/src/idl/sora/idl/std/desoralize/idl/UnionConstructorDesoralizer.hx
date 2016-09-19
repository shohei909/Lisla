package sora.idl.std.desoralize.idl;
import haxe.ds.Option;
import sora.core.Sora;
import sora.idl.desoralize.DesoralizeArrayContext;
import sora.idl.desoralize.DesoralizeContext;
import sora.idl.desoralize.DesoralizeError;
import sora.idl.desoralize.DesoralizeErrorKind;
import sora.core.ds.Result;
import sora.idl.std.data.idl.UnionConstructor;
using sora.core.ds.ResultTools;

class UnionConstructorDesoralizer
{

	public static function process(context:DesoralizeContext):Result<UnionConstructor, DesoralizeError> 
	{
		return switch (context.sora)
		{
			case Sora.Str(string):
				Result.Err(DesoralizeError.ofString(string, Option.None, DesoralizeErrorKind.CantBeString));
				
			case Sora.Arr(array):
				try
				{
					var arrayContext = new DesoralizeArrayContext(context, array, 0);
					var name = arrayContext.read(UnionConstructorNameDesoralizer.process).getOrThrow();
					var type = arrayContext.read(TypeReferenceDesoralizer.process).getOrThrow();
					arrayContext.close(UnionConstructor.new.bind(name, type));
				}
				catch (error:DesoralizeError)
				{
					Result.Err(error);
				}
		}
	}	
}