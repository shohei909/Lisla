package litll.idl.std.delitllfy;
import litll.core.Litll;
import litll.core.LitllString;
import litll.core.ds.Result;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.delitllfy.DelitllfyErrorKind;

class StringDelitllfier
{
	public static inline function process(context:DelitllfyContext):Result<LitllString, DelitllfyError> 
	{
		return switch (context.litll)
		{
			case Litll.Str(string):
				Result.Ok(string);
				
			case Litll.Arr(array):
				Result.Err(DelitllfyError.ofLitll(context.litll, DelitllfyErrorKind.CantBeArray));
		}
	}
}
