package litll.idl.std.delitllfy.idl;
import haxe.ds.Option;
import litll.core.Litll;
import litll.idl.delitllfy.LitllArrayContext;
import litll.idl.delitllfy.LitllContext;
import litll.idl.delitllfy.LitllError;
import litll.idl.delitllfy.LitllErrorKind;
import litll.core.ds.Result;
import litll.idl.std.data.idl.GenericTypeReference;
using litll.core.ds.ResultTools;

class GenericTypeReferenceLitllfier
{
	public static function process(context:LitllContext):Result<GenericTypeReference, LitllError> 
	{
		return switch (context.litll)
		{
			case Litll.Str(string):
				Result.Err(LitllError.ofString(string, Option.None, LitllErrorKind.CantBeString));
				
			case Litll.Arr(array):
				try
				{
					var arrayContext = new LitllArrayContext(context, array, 0);
					var name = arrayContext.read(TypePathLitllfier.process).getOrThrow();
					var parameters = arrayContext.readRest(TypeReferenceLitllfier.process).getOrThrow();
					arrayContext.close(GenericTypeReference.new.bind(name, parameters));
				}
				catch (error:LitllError)
				{
					Result.Err(error);
				}
		}
	}
}