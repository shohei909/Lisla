package litll.idl.std.delitllfy;
import litll.core.Litll;
import litll.core.LitllString;
import litll.core.ds.Result;
import litll.idl.delitllfy.LitllContext;
import litll.idl.delitllfy.LitllError;
import litll.idl.delitllfy.LitllErrorKind;

class StringLitllfier
{
	public static inline function process(context:LitllContext):Result<LitllString, LitllError> 
	{
		return switch (context.litll)
		{
			case Litll.Str(string):
				Result.Ok(string);
				
			case Litll.Arr(array):
				Result.Err(LitllError.ofLitll(context.litll, LitllErrorKind.CantBeArray));
		}
	}
}
