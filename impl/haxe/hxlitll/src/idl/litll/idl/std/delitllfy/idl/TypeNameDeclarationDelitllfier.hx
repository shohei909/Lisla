package litll.idl.std.delitllfy.idl;
import haxe.ds.Option;
import litll.core.Litll;
import litll.idl.delitllfy.DelitllfyArrayContext;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.core.ds.Result;
import litll.idl.std.data.idl.TypeNameDeclaration;
import litll.idl.std.data.idl.TypeParameterDeclaration;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.delitllfy.idl.GenericTypeNameDelitllfier;
import litll.idl.std.delitllfy.idl.TypeNameDeclarationDelitllfier;
import litll.idl.std.delitllfy.idl.TypeNameDelitllfier;
import litll.idl.std.delitllfy.idl.TypeParameterDeclarationDelitllfier;
using litll.core.ds.ResultTools;

class TypeNameDeclarationDelitllfier
{
	public static function process(context:DelitllfyContext):Result<TypeNameDeclaration, DelitllfyError> 
	{
		var expected = ["primitive", "parameterized"];
		return switch (context.litll)
		{
			case Litll.Arr(array) if (array.data.length >= 1):
                var arrayContext = new DelitllfyArrayContext(array, 0, context.config);
                var name = arrayContext.read(TypeNameDelitllfier.process).getOrThrow();
                var parameters = arrayContext.readRest(TypeParameterDeclarationDelitllfier.process).getOrThrow();
				Result.Ok(TypeNameDeclaration.Generic(name, parameters));
                
			case Litll.Str(data):
                var data = TypeNameDelitllfier.process(context).getOrThrow();
                Result.Ok(TypeNameDeclaration.Primitive(data));
                
			case data:
				Result.Err(DelitllfyError.ofLitll(context.litll, DelitllfyErrorKind.UnmatchedEnumConstructor(expected)));
		}
	}
}
