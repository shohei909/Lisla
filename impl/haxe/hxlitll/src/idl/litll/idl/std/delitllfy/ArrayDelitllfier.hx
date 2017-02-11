package litll.idl.std.delitllfy;
import litll.core.Litll;
import litll.core.LitllArray;
import litll.core.ds.Result;
import litll.idl.delitllfy.DelitllfyArrayContext;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.delitllfy.DelitllfyErrorKind;

class ArrayDelitllfier
{
public static function process<T>(context:DelitllfyContext, tDelitllfier):Result<LitllArray<T>, DelitllfyError> 
	{
		return switch (context.litll)
		{
			case Litll.Str(string):
				Result.Err(DelitllfyError.ofLitll(context.litll, DelitllfyErrorKind.CantBeString));
				
			case Litll.Arr(array):
				var data = [];
				for (litll in array.data)
				{
					var tContext = new DelitllfyContext(litll, context.config);
					switch (tDelitllfier.process(tContext))
					{
						case Result.Err(error):
							Result.Err(error);
						
						case Result.Ok(o):
							data.push(o);
					}
				}
				Result.Ok(new LitllArray(data, array.tag));
		}
	}
}
