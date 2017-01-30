package litll.idl.delitllfy;
import haxe.ds.Option;
import litll.core.Litll;
import litll.core.LitllArray;
import litll.core.ds.Result;

class Delitllfier
{
	public static function run<T>(processor:DelitllfyProcessor<T>, litll:LitllArray<Litll>, ?config:DelitllfyConfig):Result<T, DelitllfyError>
	{
		if (config == null)
		{
			config = new DelitllfyConfig();
		}
		
		var context = new DelitllfyContext(Litll.Arr(litll), config);
		return processor.process(context);
	}
	
	public static function processLitll(context:DelitllfyContext):Result<Litll, DelitllfyError>
	{
		return Result.Ok(context.litll);
	}
}
