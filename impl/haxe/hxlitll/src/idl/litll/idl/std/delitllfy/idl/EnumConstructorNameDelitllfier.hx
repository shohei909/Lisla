package litll.idl.std.delitllfy.idl;
import litll.core.Litll;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.delitllfy.DelitllfyErrorKind;
import litll.core.ds.Result;
import litll.idl.std.data.idl.EnumConstructorName;

class EnumConstructorNameDelitllfier
{
	public static function process(context:DelitllfyContext):Result<EnumConstructorName, DelitllfyError> 	
	{
		return switch (context.litll)
		{
			case Litll.Str(string):
				Result.Ok(new EnumConstructorName(string.data));
			
			case Litll.Arr(array):
				Result.Err(DelitllfyError.ofLitll(context.litll, DelitllfyErrorKind.CantBeArray));
		}
	}
}
