package litll.idl.std.delitllfy.core;

import haxe.ds.Option;
import litll.core.Litll;
import litll.idl.delitllfy.DelitllfyArrayContext;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.core.ds.Result;
import litll.idl.delitllfy.DelitllfyErrorKind;
import litll.idl.std.data.core.LitllOption;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.delitllfy.idl.TypePathDelitllfier;
using litll.core.ds.ResultTools;

class OptionDelitllfier
{
	public static function process<T>(tProcess:DelitllfyContext->Result<T, DelitllfyError>, context:DelitllfyContext):Result<LitllOption<T>, DelitllfyError> 
	{
		var expected = ["none", "some"];
		return switch (context.litll)
		{
			case Litll.Arr(array) if (array.data.length == 0):
                Result.Ok(LitllOption.None);
                
			case Litll.Arr(array) if (array.data.length == 1):
                var arrayContext = new DelitllfyArrayContext(array, 0, context.config);
                var data = arrayContext.read(tProcess).getOrThrow();
                Result.Ok(LitllOption.Some(data));
                
			case data:
				Result.Err(DelitllfyError.ofLitll(context.litll, DelitllfyErrorKind.UnmatchedEnumConstructor(expected)));
		}
	}
}
