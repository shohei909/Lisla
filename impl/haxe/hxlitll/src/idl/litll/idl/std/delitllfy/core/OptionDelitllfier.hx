package litll.idl.std.delitllfy.core;
import haxe.ds.Option;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.delitllfy.DelitllfyUnionContext;
import litll.core.ds.Result;
import litll.idl.std.data.core.LitllOption;
using litll.core.ds.ResultTools;

class OptionDelitllfier
{
	public static function process<T>(tProcess:DelitllfyContext->Result<T, DelitllfyError>, context:DelitllfyContext):Result<LitllOption<T>, DelitllfyError> 
	{
		return try
		{
			var unionContext = new DelitllfyUnionContext(context);
			switch (unionContext.read(UnitDelitllfier.process).getOrThrow().toOption())
			{
				case Option.Some(data):
					return Result.Ok(LitllOption.None(data));
					
				case Option.None:
			}
			switch (unionContext.read(SingleDelitllfier.process.bind(tProcess)).getOrThrow().toOption())
			{
				case Option.Some(data):
					return Result.Ok(LitllOption.Some(data));
					
				case Option.None:
			}
			unionContext.close();
		}
		catch (e:DelitllfyError)
		{
			Result.Err(e);
		}
	}
}
