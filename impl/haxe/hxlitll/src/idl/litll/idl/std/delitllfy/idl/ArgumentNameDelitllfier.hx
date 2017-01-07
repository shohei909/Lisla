package litll.idl.std.delitllfy.idl;
import haxe.ds.Option;
import litll.core.Litll;
import litll.core.ds.Maybe;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.delitllfy.DelitllfyErrorKind;
import litll.core.ds.Result;
import litll.idl.std.data.idl.ArgumentName;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.delitllfy.idl.ArgumentNameDelitllfier;

class ArgumentNameDelitllfier
{
	public static function process(context:DelitllfyContext):Result<ArgumentName, DelitllfyError> 
	{
		return switch (context.litll)
		{
			case Litll.Str(string):
				switch (ArgumentName.delitllfy(string))
				{
					case Result.Ok(data):
						Result.Ok(data);
					
					case Result.Err(err):
						Result.Err(DelitllfyError.ofString(string, Maybe.none(), err));
				}
				
			case Litll.Arr(array):
				Result.Err(DelitllfyError.ofLitll(context.litll, DelitllfyErrorKind.CantBeArray));
		}
	}
}
