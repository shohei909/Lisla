package litll.idl.std.delitllfy.core;
import haxe.ds.Option;
import litll.core.Litll;
import litll.core.ds.Maybe;
import litll.idl.delitllfy.DelitllfyArrayContext;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.delitllfy.DelitllfyErrorKind;
import litll.core.ds.Result;
import litll.idl.std.data.core.LitllSingle;
using litll.core.ds.ResultTools;

class SingleDelitllfier
{
	public static function process<T>(tProcess:DelitllfyContext->Result<T, DelitllfyError>, context:DelitllfyContext):Result<LitllSingle<T>, DelitllfyError> 	
	{
		return switch (context.litll)
		{
			case Litll.Str(string):
				Result.Err(DelitllfyError.ofString(string, Maybe.none(), DelitllfyErrorKind.CantBeString));
				
			case Litll.Arr(array):
				try
				{
					var arrayContext = new DelitllfyArrayContext(array, 0, context.config);
					var element1 = arrayContext.read(tProcess).getOrThrow();
					arrayContext.close(LitllSingle.new.bind(element1));
				}
				catch (error:DelitllfyError)
				{
					Result.Err(error);
				}
		}
	}
}