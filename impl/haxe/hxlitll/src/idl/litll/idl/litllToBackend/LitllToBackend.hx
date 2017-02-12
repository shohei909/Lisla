package litll.idl.litllToBackend;
import haxe.ds.Option;
import litll.core.Litll;
import litll.core.LitllArray;
import litll.core.ds.Result;

class LitllToBackend
{
	public static function run<T>(processor:LitllToBackendProcessor<T>, litll:LitllArray<Litll>, ?config:LitllToBackendConfig):Result<T, LitllToBackendError>
	{
		if (config == null)
		{
			config = new LitllToBackendConfig();
		}
		
		var context = new LitllToBackendContext(Litll.Arr(litll), config);
		return processor.process(context);
	}
	
	public static function processLitll(context:LitllToBackendContext):Result<Litll, LitllToBackendError>
	{
		return Result.Ok(context.litll);
	}
}
