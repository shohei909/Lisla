package litll.idl.delitllfy;
import haxe.ds.Option;
import litll.core.Litll;
import litll.core.LitllArray;
import litll.core.ds.Result;

class Delitllfier
{
	public static function run<T>(process:DelitllfyContext->Result<T, DelitllfyError>, litll:LitllArray, ?config:DelitllfyConfig):Result<T, DelitllfyError>
	{
		if (config == null)
		{
			config = new DelitllfyConfig();
		}
		
		var context = new DelitllfyContext(Option.None, Litll.Arr(litll), config);
		return process(context);
	}
	
	public static function processLitll(context:DelitllfyContext):Result<Litll, DelitllfyError>
	{
		return Result.Ok(context.litll);
	}
}
