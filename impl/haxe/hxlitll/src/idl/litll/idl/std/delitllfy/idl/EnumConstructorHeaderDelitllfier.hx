package litll.idl.std.delitllfy.idl;
import litll.core.Litll;
import litll.core.ds.Result;
import litll.idl.delitllfy.DelitllfyArrayContext;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.delitllfy.DelitllfyErrorKind;
import litll.idl.std.data.idl.EnumConstructor;
import litll.idl.std.data.idl.EnumConstructorHeader;
import litll.idl.std.delitllfy.idl.EnumConstructorHeaderDelitllfier;
import litll.idl.std.delitllfy.idl.EnumConstructorNameDelitllfier;
using litll.core.ds.ResultTools;

class EnumConstructorHeaderDelitllfier 
{
    public static function process(context:DelitllfyContext):Result<EnumConstructorHeader, DelitllfyError>
    {
		var expected = ["primitive", "parameterized"];
		return switch (context.litll)
		{
			case Litll.Arr(array) if (array.data.length == 2):
                var arrayContext = new DelitllfyArrayContext(array, 0, context.config);
                var data = arrayContext.read(EnumConstructorNameDelitllfier.process).getOrThrow();
                var condition = arrayContext.read(EnumConstuctorConditionDelitllfier.process).getOrThrow();
				Result.Ok(EnumConstructorHeader.Special(data, condition));
                
			case Litll.Str(data):
                var data = EnumConstructorNameDelitllfier.process(context).getOrThrow();
                Result.Ok(EnumConstructorHeader.Basic(data));
                
			case data:
				Result.Err(DelitllfyError.ofLitll(context.litll, DelitllfyErrorKind.UnmatchedEnumConstructor(expected)));
		}
    }
}
