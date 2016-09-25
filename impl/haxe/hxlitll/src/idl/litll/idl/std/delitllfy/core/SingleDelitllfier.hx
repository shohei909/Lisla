package litll.idl.std.delitllfy.core;
import haxe.ds.Option;
import litll.core.Litll;
import litll.idl.delitllfy.LitllArrayContext;
import litll.idl.delitllfy.LitllContext;
import litll.idl.delitllfy.LitllError;
import litll.idl.delitllfy.LitllErrorKind;
import litll.core.ds.Result;
import litll.idl.std.data.core.LitllSingle;
using litll.core.ds.ResultTools;

class SingleLitllfier
{
	public static function process<T>(tProcess:LitllContext->Result<T, LitllError>, context:LitllContext):Result<LitllSingle<T>, LitllError> 	
	{
		return switch (context.litll)
		{
			case Litll.Str(string):
				Result.Err(LitllError.ofString(string, Option.None, LitllErrorKind.CantBeString));
				
			case Litll.Arr(array):
				try
				{
					var arrayContext = new LitllArrayContext(context, array, 0);
					var element1 = arrayContext.read(tProcess).getOrThrow();
					arrayContext.close(LitllSingle.new.bind(element1));
				}
				catch (error:LitllError)
				{
					Result.Err(error);
				}
		}
	}
}