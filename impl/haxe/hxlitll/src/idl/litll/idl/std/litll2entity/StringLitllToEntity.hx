package litll.idl.std.litll2entity;
import hxext.ds.Result;
import litll.core.Litll;
import litll.core.LitllString;
import litll.idl.litll2entity.LitllToEntityContext;
import litll.idl.litll2entity.error.LitllToEntityError;
import litll.idl.litll2entity.error.LitllToEntityErrorKind;

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
