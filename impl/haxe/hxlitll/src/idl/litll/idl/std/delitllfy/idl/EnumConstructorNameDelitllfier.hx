package litll.idl.std.delitllfy.idl;
import litll.core.Litll;
import litll.idl.delitllfy.LitllContext;
import litll.idl.delitllfy.LitllError;
import litll.idl.delitllfy.LitllErrorKind;
import litll.core.ds.Result;
import litll.idl.std.data.idl.EnumConstructorName;

class EnumConstructorNameLitllfier
{
	public static function process(context:LitllContext):Result<EnumConstructorName, LitllError> 	
	{
		return switch (context.litll)
		{
			case Litll.Str(string):
				Result.Ok(new EnumConstructorName(string.data));
			
			case Litll.Arr(array):
				Result.Err(LitllError.ofLitll(context.litll, LitllErrorKind.CantBeArray));
		}
	}
}
