package litll.idl.std.delitllfy.idl;
import haxe.ds.Option;
import litll.core.Litll;
import litll.core.ds.Result;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.delitllfy.DelitllfyErrorKind;
import litll.idl.std.data.idl.TypeReferenceParameter;
import litll.idl.std.delitllfy.idl.TypeReferenceParameterDelitllfier;

class TypeReferenceParameterDelitllfier
{
	public static function process(context:DelitllfyContext):Result<TypeReferenceParameter, DelitllfyError> 
	{
		return Result.Ok(new TypeReferenceParameter(context.litll));
	}
}
