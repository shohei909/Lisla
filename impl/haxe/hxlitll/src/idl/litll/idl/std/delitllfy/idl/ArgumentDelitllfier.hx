package litll.idl.std.delitllfy.idl;
import haxe.ds.Option;
import litll.core.Litll;
import litll.core.LitllArray;
import litll.idl.delitllfy.LitllArrayContext;
import litll.idl.delitllfy.LitllContext;
import litll.idl.delitllfy.LitllError;
import litll.idl.delitllfy.LitllErrorKind;
import litll.idl.delitllfy.Litllfier;
import litll.core.ds.Result;
import litll.idl.std.data.idl.Argument;
import litll.idl.std.data.core.LitllOption;
import litll.idl.std.data.core.Unit;
import litll.idl.std.delitllfy.idl.TypeReferenceLitllfier;
import litll.idl.std.delitllfy.core.OptionLitllfier;
using litll.core.ds.ResultTools;

class ArgumentLitllfier
{
	public static function process(context:LitllContext):Result<Argument, LitllError> 
	{
		return switch (context.litll)
		{
			case Litll.Str(string):
				Result.Err(LitllError.ofString(string, Option.None, LitllErrorKind.CantBeString));
				
			case Litll.Arr(array):
				try
				{
					var arrayContext = new LitllArrayContext(context, array, 0);
					var name = arrayContext.read(ArgumentNameLitllfier.process).getOrThrow();
					var parameters = arrayContext.read(TypeReferenceLitllfier.process).getOrThrow();
					var defaultValue = arrayContext.readWithDefault(
						OptionLitllfier.process.bind(Litllfier.processLitll), 
						LitllOption.None(new Unit())
					).getOrThrow();
					arrayContext.close(Argument.new.bind(name, parameters, defaultValue));
				}
				catch (error:LitllError)
				{
					Result.Err(error);
				}
		}
	}
}
