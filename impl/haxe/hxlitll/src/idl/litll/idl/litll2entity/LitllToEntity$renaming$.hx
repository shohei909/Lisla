package litll.idl.litll2entity;
import haxe.ds.Option;
import litll.core.Litll;
import litll.core.LitllArray;
import hxext.ds.Result;

class LitllToEntity
{
	public static function run<T>(processor:LitllToEntityProcessor<T>, litll:LitllArray<Litll>, ?config:LitllToEntityConfig):Result<T, LitllToEntityError>
	{
		if (config == null)
		{
			config = new LitllToEntityConfig();
		}
		
		var context = new LitllToEntityContext(Litll.Arr(litll), config);
		return processor.process(context);
	}
	
	public static function processLitll(context:LitllToEntityContext):Result<Litll, LitllToEntityError>
	{
		return Result.Ok(context.litll);
	}
}
