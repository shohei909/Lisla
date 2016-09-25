package litll.idl.std.delitllfy.core;
import haxe.ds.Option;
import litll.idl.delitllfy.LitllContext;
import litll.idl.delitllfy.LitllError;
import litll.idl.delitllfy.LitllUnionContext;
import litll.core.ds.Result;
import litll.idl.std.data.core.LitllOption;
using litll.core.ds.ResultTools;

class OptionLitllfier
{
	public static function process<T>(tProcess:LitllContext->Result<T, LitllError>, context:LitllContext):Result<LitllOption<T>, LitllError> 
	{
		return try
		{
			var unionContext = new LitllUnionContext(context);
			switch (unionContext.read(UnitLitllfier.process).getOrThrow())
			{
				case Option.Some(data):
					return Result.Ok(LitllOption.None(data));
					
				case Option.None:
			}
			switch (unionContext.read(SingleLitllfier.process.bind(tProcess)).getOrThrow())
			{
				case Option.Some(data):
					return Result.Ok(LitllOption.Some(data));
					
				case Option.None:
			}
			unionContext.close();
		}
		catch (e:LitllError)
		{
			Result.Err(e);
		}
	}
}
