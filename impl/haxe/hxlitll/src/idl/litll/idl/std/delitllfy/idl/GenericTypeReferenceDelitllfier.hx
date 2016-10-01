package litll.idl.std.delitllfy.idl;
import haxe.ds.Option;
import litll.core.Litll;
import litll.idl.delitllfy.DelitllfyArrayContext;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.delitllfy.DelitllfyErrorKind;
import litll.core.ds.Result;
import litll.idl.std.data.idl.GenericTypeReference;
import litll.idl.std.delitllfy.idl.GenericTypeReferenceDelitllfier;
import litll.idl.std.delitllfy.idl.TypePathDelitllfier;
import litll.idl.std.delitllfy.idl.TypeReferenceDelitllfier;
using litll.core.ds.ResultTools;

class GenericTypeReferenceDelitllfier
{
	public static function process(context:DelitllfyContext):Result<GenericTypeReference, DelitllfyError> 
	{
		return switch (context.litll)
		{
			case Litll.Str(string):
				Result.Err(DelitllfyError.ofString(string, Option.None, DelitllfyErrorKind.CantBeString));
				
			case Litll.Arr(array):
				try
				{
					var arrayContext = new DelitllfyArrayContext(context, array, 0);
					var name = arrayContext.read(TypePathDelitllfier.process).getOrThrow();
					var parameters = arrayContext.readRest(TypeReferenceParameterDelitllfier.process).getOrThrow();
					arrayContext.close(GenericTypeReference.new.bind(name, parameters));
				}
				catch (error:DelitllfyError)
				{
					Result.Err(error);
				}
		}
	}
}
