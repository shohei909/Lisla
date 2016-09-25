package litll.idl.std.delitllfy.idl;
import haxe.ds.Option;
import litll.core.Litll;
import litll.idl.delitllfy.LitllContext;
import litll.idl.delitllfy.LitllError;
import litll.idl.delitllfy.LitllErrorKind;
import litll.core.ds.Result;
import litll.idl.std.data.idl.ModulePath;

class FilePathLitllfier
{
	public static function process(context:LitllContext):Result<ModulePath, LitllError> 
	{
		return switch (StringLitllfier.process(context))
		{
			case Result.Ok(string):
				switch (ModulePath.create(string.data))
				{
					case Result.Ok(data):
						Result.Ok(data);
					
					case Result.Err(message):
						Result.Err(LitllError.ofString(string, Option.None, LitllErrorKind.Unknown(message)));
				}
				
			case Result.Err(error):
				Result.Err(error);
		}
	}
}
