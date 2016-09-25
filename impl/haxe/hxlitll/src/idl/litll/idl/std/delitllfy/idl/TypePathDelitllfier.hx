package litll.idl.std.delitllfy.idl;
import haxe.ds.Option;
import litll.core.Litll;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.delitllfy.DelitllfyErrorKind;
import litll.core.ds.Result;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.TypeReference;

class TypePathDelitllfier
{
	public static function process(context:DelitllfyContext):Result<TypePath, DelitllfyError>  
	{
		return switch (context.litll)
		{
			case Litll.Str(string):
				switch (TypePath.create(string.data))
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