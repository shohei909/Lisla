package litll.idl.std.delitllfy.idl;
import haxe.ds.Option;
import litll.core.Litll;
import litll.core.ds.Maybe;
import litll.idl.delitllfy.DelitllfyArrayContext;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.delitllfy.DelitllfyErrorKind;
import litll.core.ds.Result;
import litll.idl.std.data.idl.ParameterizedEnumConstructor;
import litll.idl.std.delitllfy.idl.ArgumentDelitllfier;
import litll.idl.std.delitllfy.idl.EnumConstructorNameDelitllfier;
import litll.idl.std.delitllfy.idl.ParameterizedEnumConstructorDelitllfier;
using litll.core.ds.ResultTools;

class ParameterizedEnumConstructorDelitllfier
{
	public static function process(context:DelitllfyContext):Result<ParameterizedEnumConstructor, DelitllfyError> 
	{
		return switch (context.litll)
		{
			case Litll.Str(string):
				Result.Err(DelitllfyError.ofString(string, Maybe.none(), DelitllfyErrorKind.CantBeString));
				
			case Litll.Arr(array):
				try
				{
					var arrayContext = new DelitllfyArrayContext(array, 0, context.config);
					var name = arrayContext.read(EnumConstructorNameDelitllfier.process).getOrThrow();
					var arguments = arrayContext.readRest(ArgumentDelitllfier.process).getOrThrow();
					arrayContext.close(ParameterizedEnumConstructor.new.bind(name, arguments));
				}
				catch (error:DelitllfyError)
				{
					Result.Err(error);
				}
		}
	}
}
