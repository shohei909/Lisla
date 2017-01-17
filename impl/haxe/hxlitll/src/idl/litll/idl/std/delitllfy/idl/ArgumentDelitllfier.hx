package litll.idl.std.delitllfy.idl;
import haxe.ds.Option;
import litll.core.Litll;
import litll.core.LitllArray;
import litll.core.ds.Maybe;
import litll.idl.delitllfy.DelitllfyArrayContext;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.delitllfy.DelitllfyErrorKind;
import litll.idl.delitllfy.Delitllfier;
import litll.core.ds.Result;
import litll.idl.std.data.idl.Argument;
import litll.idl.std.data.core.LitllOption;
import litll.idl.std.data.core.Unit;
import litll.idl.std.delitllfy.idl.ArgumentDelitllfier;
import litll.idl.std.delitllfy.idl.ArgumentNameDelitllfier;
import litll.idl.std.delitllfy.idl.TypeReferenceDelitllfier;
import litll.idl.std.delitllfy.core.OptionDelitllfier;
using litll.core.ds.ResultTools;

class ArgumentDelitllfier
{
	public static function process(context:DelitllfyContext):Result<Argument, DelitllfyError> 
	{
		return switch (context.litll)
		{
			case Litll.Str(string):
				Result.Err(DelitllfyError.ofString(string, Maybe.none(), DelitllfyErrorKind.CantBeString));
				
			case Litll.Arr(array):
				try
				{
					var arrayContext = new DelitllfyArrayContext(array, 0, context.config);
					var name = arrayContext.read(ArgumentNameDelitllfier.process).getOrThrow();
					var parameters = arrayContext.read(TypeReferenceDelitllfier.process).getOrThrow();
					var defaultValue = arrayContext.readOptional(Delitllfier.processLitll).getOrThrow();
					arrayContext.close(Argument.new.bind(name, parameters, defaultValue));
				}
				catch (error:DelitllfyError)
				{
					Result.Err(error);
				}
		}
	}
}
