package litll.idl.std.delitllfy;
import litll.core.Litll;
import litll.core.LitllArray;
import litll.core.ds.Result;
import litll.idl.delitllfy.LitllContext;
import litll.idl.delitllfy.LitllError;
import litll.idl.delitllfy.LitllErrorKind;

class ArrayLitllfier
{
	public function process(context:LitllContext):Result<LitllArray, LitllError> 
	{
		return switch (context.litll)
		{
			case Litll.Str(string):
				Result.Err(LitllError.ofLitll(context.litll, LitllErrorKind.CantBeString));
				
			case Litll.Arr(array):
				Result.Ok(array);
		}
	}
}
