package litll.idl.std.litll2backend;
import litll.core.Litll;
import litll.core.LitllArray;
import litll.core.ds.Result;
import litll.idl.litll2backend.LitllToEntityArrayContext;
import litll.idl.litll2backend.LitllToEntityContext;
import litll.idl.litll2backend.LitllToEntityError;
import litll.idl.litll2backend.LitllToEntityErrorKind;

class ArrayLitllToEntity
{
public static function process<T>(context:LitllToEntityContext, tLitllToEntity):Result<LitllArray<T>, LitllToEntityError> 
	{
		return switch (context.litll)
		{
			case Litll.Str(string):
				Result.Err(LitllToEntityError.ofLitll(context.litll, LitllToEntityErrorKind.CantBeString));
				
			case Litll.Arr(array):
				var data = [];
				for (litll in array.data)
				{
					var tContext = new LitllToEntityContext(litll, context.config);
					switch (tLitllToEntity.process(tContext))
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
