package litll.idl.std.litll2backend;
import litll.core.Litll;
import litll.core.LitllString;
import litll.core.ds.Result;
import litll.idl.litll2backend.LitllToEntityContext;
import litll.idl.litll2backend.LitllToEntityError;
import litll.idl.litll2backend.LitllToEntityErrorKind;

class StringLitllToEntity
{
	public static inline function process(context:LitllToEntityContext):Result<LitllString, LitllToEntityError> 
	{
		return switch (context.litll)
		{
			case Litll.Str(string):
				Result.Ok(string);
				
			case Litll.Arr(array):
				Result.Err(LitllToEntityError.ofLitll(context.litll, LitllToEntityErrorKind.CantBeArray));
		}
	}
}
