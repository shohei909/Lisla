package litll.idl.std.litll2backend;
import litll.core.Litll;
import litll.core.LitllString;
import litll.core.ds.Result;
import litll.idl.litll2backend.LitllToBackendContext;
import litll.idl.litll2backend.LitllToBackendError;
import litll.idl.litll2backend.LitllToBackendErrorKind;

class StringLitllToBackend
{
	public static inline function process(context:LitllToBackendContext):Result<LitllString, LitllToBackendError> 
	{
		return switch (context.litll)
		{
			case Litll.Str(string):
				Result.Ok(string);
				
			case Litll.Arr(array):
				Result.Err(LitllToBackendError.ofLitll(context.litll, LitllToBackendErrorKind.CantBeArray));
		}
	}
}
