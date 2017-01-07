package litll.idl.std.delitllfy.idl;
import haxe.ds.Option;
import litll.core.Litll;
import litll.core.ds.Maybe;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.delitllfy.DelitllfyErrorKind;
import litll.core.ds.Result;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.delitllfy.idl.TypeNameDelitllfier;

class TypeNameDelitllfier
{
	public static function process(context:DelitllfyContext):Result<TypeName, DelitllfyError> 
	{
		return switch (context.litll)
		{
			case Litll.Str(string):
				switch (TypeName.create(string.data))
				{
					case Result.Ok(data):
						Result.Ok(data);
					
					case Result.Err(message):
						Result.Err(DelitllfyError.ofString(string, Maybe.none(), DelitllfyErrorKind.Fatal(message)));
				}
				
			case Litll.Arr(array):
				Result.Err(DelitllfyError.ofLitll(context.litll, DelitllfyErrorKind.CantBeArray));
		}
	}
}
