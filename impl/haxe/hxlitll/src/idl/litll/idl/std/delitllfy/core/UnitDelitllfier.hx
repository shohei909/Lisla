package litll.idl.std.delitllfy.core;
import haxe.ds.Option;
import litll.core.Litll;
import litll.idl.delitllfy.DelitllfyArrayContext;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.delitllfy.DelitllfyErrorKind;
import litll.core.ds.Result;
import litll.idl.std.data.core.Unit;

class UnitDelitllfier
{
	public static function process(context:DelitllfyContext):Result<Unit, DelitllfyError>
	{
		return switch (context.litll)
		{
			case Litll.Str(string):
				Result.Err(DelitllfyError.ofString(string, Option.None, DelitllfyErrorKind.CantBeString));
				
			case Litll.Arr(array):
				try
				{
					var arrayContext = new DelitllfyArrayContext(context, array, 0);
					arrayContext.close(Unit.new);
				}
				catch (error:DelitllfyError)
				{
					Result.Err(error);
				}
		}
	}	
}
