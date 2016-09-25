package litll.idl.std.delitllfy.core;
import haxe.ds.Option;
import litll.core.Litll;
import litll.idl.delitllfy.LitllArrayContext;
import litll.idl.delitllfy.LitllContext;
import litll.idl.delitllfy.LitllError;
import litll.idl.delitllfy.LitllErrorKind;
import litll.core.ds.Result;
import litll.idl.std.data.core.Unit;

class UnitLitllfier
{
	public static function process(context:LitllContext):Result<Unit, LitllError>
	{
		return switch (context.litll)
		{
			case Litll.Str(string):
				Result.Err(LitllError.ofString(string, Option.None, LitllErrorKind.CantBeString));
				
			case Litll.Arr(array):
				try
				{
					var arrayContext = new LitllArrayContext(context, array, 0);
					arrayContext.close(Unit.new);
				}
				catch (error:LitllError)
				{
					Result.Err(error);
				}
		}
	}	
}
