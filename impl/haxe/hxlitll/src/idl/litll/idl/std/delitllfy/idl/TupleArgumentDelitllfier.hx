package litll.idl.std.delitllfy.idl;
import litll.core.Litll;
import litll.core.ds.Result;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.delitllfy.DelitllfyErrorKind;
import litll.idl.std.data.idl.TupleElement;
import litll.idl.std.data.idl.EnumConstructorName;
import litll.idl.std.delitllfy.idl.ArgumentDelitllfier;
import litll.idl.std.delitllfy.idl.TupleElementDelitllfier;
using litll.core.ds.ResultTools;

class TupleElementDelitllfier
{
    public static function process(context:DelitllfyContext):Result<TupleElement, DelitllfyError>
    {
		var expected = ["primitive", "parameterized"];
		return switch (context.litll)
		{
			case Litll.Arr(array):
                var data = ArgumentDelitllfier.process(context).getOrThrow();
				Result.Ok(TupleElement.Data(data));
                
			case Litll.Str(data):
                Result.Ok(TupleElement.Label(data));
                
			case data:
				Result.Err(DelitllfyError.ofLitll(context.litll, DelitllfyErrorKind.UnmatchedEnumConstructor(expected)));
		}
    }
}
