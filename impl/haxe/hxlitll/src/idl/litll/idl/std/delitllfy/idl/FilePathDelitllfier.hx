package litll.idl.std.delitllfy.idl;
import haxe.ds.Option;
import litll.core.Litll;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.delitllfy.DelitllfyErrorKind;
import litll.core.ds.Result;
import litll.idl.std.data.idl.ModulePath;

class FilePathDelitllfier
{
	public static function process(context:DelitllfyContext):Result<ModulePath, DelitllfyError> 
	{
		return switch (StringDelitllfier.process(context))
		{
			case Result.Ok(string):
				switch (ModulePath.create(string.data))
				{
					case Result.Ok(data):
						Result.Ok(data);
					
					case Result.Err(message):
						Result.Err(DelitllfyError.ofString(string, Option.None, DelitllfyErrorKind.Unknown(message)));
				}
				
			case Result.Err(error):
				Result.Err(error);
		}
	}
}
