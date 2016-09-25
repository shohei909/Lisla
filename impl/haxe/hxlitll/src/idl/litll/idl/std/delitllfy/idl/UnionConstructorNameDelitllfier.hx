package litll.idl.std.delitllfy.idl;
import haxe.ds.Option;
import litll.core.Litll;
import litll.core.ds.Result;
import litll.idl.delitllfy.LitllContext;
import litll.idl.delitllfy.LitllError;
import litll.idl.delitllfy.LitllErrorKind;
import litll.idl.std.data.idl.UnionConstructorName;

class UnionConstructorNameLitllfier
{
	public static function process(context:LitllContext):Result<UnionConstructorName, LitllError> 	
	{
		return switch (context.litll)
		{
			case Litll.Str(string):
				switch(UnionConstructorName.create(string.data))
				{
					case Result.Ok(data):
						Result.Ok(data);
					
					case Result.Err(message):
						Result.Err(LitllError.ofString(string, Option.None, LitllErrorKind.Unknown(message)));
				}
			case Litll.Arr(array):
				Result.Err(LitllError.ofLitll(context.litll, LitllErrorKind.CantBeArray));
		}
	}	
}
