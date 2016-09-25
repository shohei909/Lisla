package litll.idl.std.delitllfy.idl;
import haxe.ds.Option;
import litll.core.Litll;
import litll.idl.delitllfy.LitllArrayContext;
import litll.idl.delitllfy.LitllContext;
import litll.idl.delitllfy.LitllError;
import litll.idl.delitllfy.LitllErrorKind;
import litll.core.ds.Result;
import litll.idl.std.data.idl.ParameterizedEnumConstructor;
using litll.core.ds.ResultTools;

class ParameterizedEnumConstructorLitllfier
{
	public static function process(context:LitllContext):Result<ParameterizedEnumConstructor, LitllError> 
	{
		return switch (context.litll)
		{
			case Litll.Str(string):
				Result.Err(LitllError.ofString(string, Option.None, LitllErrorKind.CantBeString));
				
			case Litll.Arr(array):
				try
				{
					var arrayContext = new LitllArrayContext(context, array, 0);
					var name = arrayContext.read(EnumConstructorNameLitllfier.process).getOrThrow();
					var arguments = arrayContext.readRest(ArgumentLitllfier.process).getOrThrow();
					arrayContext.close(ParameterizedEnumConstructor.new.bind(name, arguments));
				}
				catch (error:LitllError)
				{
					Result.Err(error);
				}
		}
	}
}
