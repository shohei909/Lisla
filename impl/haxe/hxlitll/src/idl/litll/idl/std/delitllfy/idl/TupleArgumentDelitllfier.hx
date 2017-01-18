package litll.idl.std.delitllfy.idl;
import litll.core.Litll;
import litll.core.ds.Result;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.delitllfy.DelitllfyErrorKind;
import litll.idl.std.data.idl.TupleArgument;
import litll.idl.std.data.idl.EnumConstructorName;
import litll.idl.std.delitllfy.idl.ArgumentDelitllfier;
import litll.idl.std.delitllfy.idl.TupleArgumentDelitllfier;
using litll.core.ds.ResultTools;

class TupleArgumentDelitllfier
{
    public static function process(context:DelitllfyContext):Result<TupleArgument, DelitllfyError>
    {
		var expected = ["primitive", "parameterized"];
		return switch (context.litll)
		{
			case Litll.Arr(array):
                var data = ArgumentDelitllfier.process(context).getOrThrow();
				Result.Ok(TupleArgument.Data(data));
                
			case Litll.Str(data):
                Result.Ok(TupleArgument.Label(data));
                
			case data:
				Result.Err(DelitllfyError.ofLitll(context.litll, DelitllfyErrorKind.UnmatchedEnumConstructor(expected)));
		}
    }
}
