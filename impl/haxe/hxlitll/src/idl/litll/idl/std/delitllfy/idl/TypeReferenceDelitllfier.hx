package litll.idl.std.delitllfy.idl;
import haxe.ds.Option;
import litll.idl.delitllfy.LitllContext;
import litll.idl.delitllfy.LitllError;
import litll.idl.delitllfy.LitllUnionContext;
import litll.core.ds.Result;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.delitllfy.idl.GenericTypeReferenceLitllfier;
import litll.idl.std.delitllfy.idl.TypePathLitllfier;
using litll.core.ds.ResultTools;

class TypeReferenceLitllfier
{
	public static function process(context:LitllContext):Result<TypeReference, LitllError> 
	{
		return try
		{
			var unionContext = new LitllUnionContext(context);
			switch (unionContext.read(TypePathLitllfier.process).getOrThrow())
			{
				case Option.Some(data):
					return Result.Ok(TypeReference.Primitive(data));
					
				case Option.None:
			}
			switch (unionContext.read(GenericTypeReferenceLitllfier.process).getOrThrow())
			{
				case Option.Some(data):
					return Result.Ok(TypeReference.Generic(data));
					
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
