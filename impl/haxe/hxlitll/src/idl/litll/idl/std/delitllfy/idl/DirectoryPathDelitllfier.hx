package litll.idl.std.delitllfy.idl;
import haxe.ds.Option;
import litll.core.Litll;
import litll.idl.delitllfy.LitllContext;
import litll.idl.delitllfy.LitllError;
import litll.idl.delitllfy.LitllErrorKind;
import litll.core.ds.Result;
import litll.idl.std.data.idl.PackagePath;

class DirectoryPathLitllfier
{
	public static function process(context:LitllContext):Result<PackagePath, LitllError> 
	{
		return switch (context.litll)
		{
			case Litll.Str(string):
				switch (PackagePath.create(string.data))
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
