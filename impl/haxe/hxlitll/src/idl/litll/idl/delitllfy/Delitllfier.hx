package litll.idl.delitllfy;
import haxe.ds.Option;
import litll.core.Litll;
import litll.core.LitllArray;
import litll.core.ds.Result;

class Litllfier
{
	public static function run<T>(process:LitllContext->Result<T, LitllError>, litll:LitllArray, ?config:LitllConfig):Result<T, LitllError>
	{
		if (config == null)
		{
			config = new LitllConfig();
		}
		
		var context = new LitllContext(Option.None, Litll.Arr(litll), config);
		return process(context);
	}
	
	public static function processLitll(context:LitllContext):Result<Litll, LitllError>
	{
		return Result.Ok(context.litll);
	}
}
