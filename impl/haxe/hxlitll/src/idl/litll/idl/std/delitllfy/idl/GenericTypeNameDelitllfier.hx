package litll.idl.std.delitllfy.idl;
import haxe.ds.Option;
import litll.core.Litll;
import litll.idl.delitllfy.DelitllfyArrayContext;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.delitllfy.DelitllfyErrorKind;
import litll.core.ds.Result;
import litll.idl.std.data.idl.GenericTypeName;
using litll.core.ds.ResultTools;

class GenericTypeNameDelitllfier
{
	public static function process(context:DelitllfyContext):Result<GenericTypeName, DelitllfyError> 
	{
		return switch (context.litll)
		{
			case Litll.Str(string):
				Result.Err(DelitllfyError.ofString(string, Option.None, DelitllfyErrorKind.CantBeString));
				
			case Litll.Arr(array):
				try
				{
					var arrayContext = new DelitllfyArrayContext(context, array, 0);
					var name = arrayContext.read(TypeNameDelitllfier.process).getOrThrow();
					var parameters = arrayContext.readRest(TypeParameterDeclarationDelitllfier.process).getOrThrow();
					arrayContext.close(GenericTypeName.new.bind(name, parameters));
				}
				catch (error:DelitllfyError)
				{
					Result.Err(error);
				}
		}
	}
}