package litll.idl.std.delitllfy;
import litll.core.Litll;
import litll.core.LitllArray;
import litll.core.ds.Result;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.delitllfy.DelitllfyErrorKind;

class ArrayDelitllfier
{
	public function process(context:DelitllfyContext):Result<LitllArray, DelitllfyError> 
	{
		return switch (context.litll)
		{
			case Litll.Str(string):
				Result.Err(DelitllfyError.ofLitll(context.litll, DelitllfyErrorKind.CantBeString));
				
			case Litll.Arr(array):
				Result.Ok(array);
		}
	}
}
