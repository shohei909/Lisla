package litll.idl.std.delitllfy.idl;
import litll.core.Litll;
import litll.core.ds.Result;
import litll.idl.delitllfy.DelitllfyArrayContext;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.delitllfy.DelitllfyErrorKind;
import litll.idl.std.data.idl.EnumConstructor;
import litll.idl.std.delitllfy.idl.EnumConstructorDelitllfier;
import litll.idl.std.delitllfy.idl.EnumConstructorHeaderDelitllfier;
import litll.idl.std.delitllfy.idl.EnumConstructorNameDelitllfier;
import litll.idl.std.delitllfy.idl.TupleArgumentDelitllfier;
using litll.core.ds.ResultTools;

class EnumConstructorDelitllfier
{
	public static function process(context:DelitllfyContext):Result<EnumConstructor, DelitllfyError> 
	{
		var expected = ["primitive", "parameterized"];
		return switch (context.litll)
		{
			case Litll.Arr(array) if (array.data.length >= 1):
                var arrayContext = new DelitllfyArrayContext(array, 0, context.config);
                var header = arrayContext.read(EnumConstructorHeaderDelitllfier.process).getOrThrow();
                var parameters = arrayContext.readRest(TupleArgumentDelitllfier.process).getOrThrow();
				Result.Ok(EnumConstructor.Parameterized(header, parameters));
                
			case Litll.Str(data):
                var data = EnumConstructorNameDelitllfier.process(context).getOrThrow();
                Result.Ok(EnumConstructor.Primitive(data));
                
			case data:
				Result.Err(DelitllfyError.ofLitll(context.litll, DelitllfyErrorKind.UnmatchedEnumConstructor(expected)));
		}
	}
}
