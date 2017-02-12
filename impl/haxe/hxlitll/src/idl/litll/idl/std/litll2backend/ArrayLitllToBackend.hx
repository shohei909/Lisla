package litll.idl.std.litll2backend;
import litll.core.Litll;
import litll.core.LitllArray;
import litll.core.ds.Result;
import litll.idl.litll2backend.LitllToBackendArrayContext;
import litll.idl.litll2backend.LitllToBackendContext;
import litll.idl.litll2backend.LitllToBackendError;
import litll.idl.litll2backend.LitllToBackendErrorKind;

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
