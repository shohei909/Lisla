package litll.idl.std.delitllfy.idl;
import haxe.ds.Option;
import litll.idl.delitllfy.LitllContext;
import litll.idl.delitllfy.LitllError;
import litll.idl.delitllfy.LitllUnionContext;
import litll.core.ds.Result;
import litll.idl.std.data.idl.TypeNameDeclaration;
using litll.core.ds.ResultTools;

class TypeNameDeclarationLitllfier
{
	public static function process(context:LitllContext):Result<TypeNameDeclaration, LitllError> 
	{
		return try
		{
			var unionContext = new LitllUnionContext(context);
			switch (unionContext.read(TypeNameLitllfier.process).getOrThrow())
			{
				case Option.Some(data):
					return Result.Ok(TypeNameDeclaration.Primitive(data));
					
				case Option.None:
			}
			switch (unionContext.read(GenericTypeNameLitllfier.process).getOrThrow())
			{
				case Option.Some(data):
					return Result.Ok(TypeNameDeclaration.Generic(data));
					
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
