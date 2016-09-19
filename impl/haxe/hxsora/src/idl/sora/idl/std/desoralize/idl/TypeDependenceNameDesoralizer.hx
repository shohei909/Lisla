package sora.idl.std.desoralize.idl;
import haxe.ds.Option;
import sora.core.Sora;
import sora.core.ds.Result;
import sora.idl.desoralize.DesoralizeContext;
import sora.idl.desoralize.DesoralizeError;
import sora.idl.desoralize.DesoralizeErrorKind;
import sora.idl.std.data.idl.TypeDependenceName;
import sora.idl.std.data.idl.UnionConstructorName;

class TypeDependenceNameDesoralizer
{
	public static function process(context:DesoralizeContext):Result<TypeDependenceName, DesoralizeError> 	
	{
		return switch (context.sora)
		{
			case Sora.Str(string):
				switch(TypeDependenceName.create(string.data))
				{
					case Result.Ok(data):
						Result.Ok(data);
					
					case Result.Err(message):
						Result.Err(DesoralizeError.ofString(string, Option.None, DesoralizeErrorKind.Unknown(message)));
				}
			
			case Sora.Arr(array):
				Result.Err(DesoralizeError.ofSora(context.sora, DesoralizeErrorKind.CantBeArray));
		}
	}	
}
