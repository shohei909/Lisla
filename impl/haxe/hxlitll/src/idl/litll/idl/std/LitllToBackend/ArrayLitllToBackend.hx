package litll.idl.std.litllToBackend;
import litll.core.Litll;
import litll.core.LitllArray;
import litll.core.ds.Result;
import litll.idl.litllToBackend.LitllToBackendArrayContext;
import litll.idl.litllToBackend.LitllToBackendContext;
import litll.idl.litllToBackend.LitllToBackendError;
import litll.idl.litllToBackend.LitllToBackendErrorKind;

class ArrayLitllToBackend
{
public static function process<T>(context:LitllToBackendContext, tLitllToBackend):Result<LitllArray<T>, LitllToBackendError> 
	{
		return switch (context.litll)
		{
			case Litll.Str(string):
				Result.Err(LitllToBackendError.ofLitll(context.litll, LitllToBackendErrorKind.CantBeString));
				
			case Litll.Arr(array):
				var data = [];
				for (litll in array.data)
				{
					var tContext = new LitllToBackendContext(litll, context.config);
					switch (tLitllToBackend.process(tContext))
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
