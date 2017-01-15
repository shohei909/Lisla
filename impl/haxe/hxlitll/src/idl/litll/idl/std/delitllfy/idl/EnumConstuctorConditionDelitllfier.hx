package litll.idl.std.delitllfy.idl;
import litll.core.Litll;
import litll.core.ds.Result;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.delitllfy.DelitllfyErrorKind;
import litll.idl.std.data.idl.EnumConstructorCondition;
import litll.idl.std.data.idl.EnumConstructorHeader;

class EnumConstuctorConditionDelitllfier 
{
    public static function process(context:DelitllfyContext):Result<EnumConstructorCondition, DelitllfyError>
    {
		var expected = ["primitive", "parameterized"];
		return switch (context.litll)
		{
			case Litll.Str(data) if (data.data == "unfold"):
                Result.Ok(EnumConstructorCondition.Unfold);
                
			case Litll.Str(data) if (data.data == "tuple"):
                Result.Ok(EnumConstructorCondition.Tuple);
                
			case data:
				Result.Err(DelitllfyError.ofLitll(context.litll, DelitllfyErrorKind.UnmatchedEnumConstructor(expected)));
		}
    }
}
