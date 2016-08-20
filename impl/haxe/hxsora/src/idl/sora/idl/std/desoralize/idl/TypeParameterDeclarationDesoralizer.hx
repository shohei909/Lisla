package sora.idl.std.desoralize.idl;
import haxe.ds.Option;
import sora.idl.desoralize.DesoralizeContext;
import sora.idl.desoralize.DesoralizeError;
import sora.idl.desoralize.DesoralizeUnionContext;
import sora.core.ds.Result;
import sora.idl.std.data.idl.TypeParameterDeclaration;
using sora.core.ds.ResultTools;

class TypeParameterDeclarationDesoralizer
{
	public static function process(context:DesoralizeContext):Result<TypeParameterDeclaration, DesoralizeError> 
	{
		return try
		{
			var unionContext = new DesoralizeUnionContext(context);
			switch (unionContext.read(TypeNameDesoralizer.process).getOrThrow())
			{
				case Option.Some(data):
					return Result.Ok(TypeParameterDeclaration.TypeName(data));
					
				case Option.None:
			}
			switch (unionContext.read(DependentTypeParameterDeclarationDesoralizer.process).getOrThrow())
			{
				case Option.Some(data):
					return Result.Ok(TypeParameterDeclaration.Dependent(data));
					
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