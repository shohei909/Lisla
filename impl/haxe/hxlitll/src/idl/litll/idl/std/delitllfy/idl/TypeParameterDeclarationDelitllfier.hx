package litll.idl.std.delitllfy.idl;
import haxe.ds.Option;
import litll.idl.delitllfy.LitllContext;
import litll.idl.delitllfy.LitllError;
import litll.idl.delitllfy.LitllUnionContext;
import litll.core.ds.Result;
import litll.idl.std.data.idl.TypeParameterDeclaration;
using litll.core.ds.ResultTools;

class TypeParameterDeclarationLitllfier
{
	public static function process(context:LitllContext):Result<TypeParameterDeclaration, LitllError> 
	{
		return try
		{
			var unionContext = new LitllUnionContext(context);
			switch (unionContext.read(TypeNameLitllfier.process).getOrThrow())
			{
				case Option.Some(data):
					return Result.Ok(TypeParameterDeclaration.TypeName(data));
					
				case Option.None:
			}
			switch (unionContext.read(TypeDependenceDeclarationLitllfier.process).getOrThrow())
			{
				case Option.Some(data):
					return Result.Ok(TypeParameterDeclaration.Dependence(data));
					
				case Option.None:
			}
			unionContext.close();
		}
		catch (e:LitllError)
		{
			Result.Err(e);
		}
	}
}