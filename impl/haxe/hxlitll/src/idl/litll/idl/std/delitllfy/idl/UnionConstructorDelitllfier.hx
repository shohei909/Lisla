package litll.idl.std.delitllfy.idl;
import haxe.ds.Option;
import litll.core.Litll;
import litll.idl.delitllfy.DelitllfyArrayContext;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.delitllfy.DelitllfyErrorKind;
import litll.core.ds.Result;
import litll.idl.std.data.idl.UnionConstructor;
import litll.idl.std.delitllfy.idl.TypeReferenceDelitllfier;
import litll.idl.std.delitllfy.idl.UnionConstructorDelitllfier;
import litll.idl.std.delitllfy.idl.UnionConstructorNameDelitllfier;
using litll.core.ds.ResultTools;

class UnionConstructorDelitllfier
{

	public static function process(context:DelitllfyContext):Result<UnionConstructor, DelitllfyError> 
	{
		return switch (context.litll)
		{
			case Litll.Str(string):
				Result.Err(DelitllfyError.ofString(string, Option.None, DelitllfyErrorKind.CantBeString));
				
			case Litll.Arr(array):
				try
				{
					var arrayContext = new DelitllfyArrayContext(context, array, 0);
					var name = arrayContext.read(UnionConstructorNameDelitllfier.process).getOrThrow();
					var type = arrayContext.read(TypeReferenceDelitllfier.process).getOrThrow();
					arrayContext.close(UnionConstructor.new.bind(name, type));
				}
				catch (error:DelitllfyError)
				{
					Result.Err(error);
				}
		}
	}	
}