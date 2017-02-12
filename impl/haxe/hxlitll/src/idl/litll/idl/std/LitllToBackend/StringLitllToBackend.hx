package litll.idl.std.litllToBackend;
import litll.core.Litll;
import litll.core.LitllString;
import litll.core.ds.Result;
import litll.idl.litllToBackend.LitllToBackendContext;
import litll.idl.litllToBackend.LitllToBackendError;
import litll.idl.litllToBackend.LitllToBackendErrorKind;

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
