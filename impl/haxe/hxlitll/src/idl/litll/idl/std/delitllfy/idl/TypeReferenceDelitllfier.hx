package litll.idl.std.delitllfy.idl;
import haxe.ds.Option;
import litll.core.Litll;
import litll.idl.delitllfy.DelitllfyArrayContext;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.core.ds.Result;
import litll.idl.delitllfy.DelitllfyErrorKind;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.delitllfy.idl.GenericTypeReferenceDelitllfier;
import litll.idl.std.delitllfy.idl.TypePathDelitllfier;
import litll.idl.std.delitllfy.idl.TypeReferenceDelitllfier;
using litll.core.ds.ResultTools;

class TypeReferenceDelitllfier
{
	public static function process(context:DelitllfyContext):Result<TypeReference, DelitllfyError> 
	{
		var expected = ["primitive", "enum"];
		return switch (context.litll)
		{
			case Litll.Arr(array) if (array.data.length >= 1):
                var arrayContext = new DelitllfyArrayContext(array, 0, context.config);
                var name = arrayContext.read(TypePathDelitllfier.process).getOrThrow();
                var parameters = arrayContext.readRest(TypeReferenceParameterDelitllfier.process).getOrThrow();
				Result.Ok(TypeReference.Generic(name, parameters));
                
			case Litll.Str(data):
                var data = TypePathDelitllfier.process(context).getOrThrow();
                Result.Ok(TypeReference.Primitive(data));
                
			case _:
				Result.Err(DelitllfyError.ofLitll(context.litll, DelitllfyErrorKind.UnmatchedEnumConstructor(expected)));
		}
	}
}
