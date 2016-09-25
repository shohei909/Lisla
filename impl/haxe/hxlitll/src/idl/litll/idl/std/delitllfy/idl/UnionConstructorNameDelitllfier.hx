package litll.idl.std.delitllfy.idl;
import haxe.ds.Option;
import litll.core.Litll;
import litll.core.ds.Result;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.delitllfy.DelitllfyErrorKind;
import litll.idl.std.data.idl.UnionConstructorName;

class UnionConstructorNameDelitllfier
{
	public static function process(context:DelitllfyContext):Result<UnionConstructorName, DelitllfyError> 	
	{
		return switch (context.litll)
		{
			case Litll.Str(string):
				switch(UnionConstructorName.create(string.data))
				{
					case Result.Ok(data):
						Result.Ok(data);
					
					case Result.Err(message):
						Result.Err(DelitllfyError.ofString(string, Option.None, DelitllfyErrorKind.Unknown(message)));
				}
			case Litll.Arr(array):
				Result.Err(DelitllfyError.ofLitll(context.litll, DelitllfyErrorKind.CantBeArray));
		}
	}	
}
