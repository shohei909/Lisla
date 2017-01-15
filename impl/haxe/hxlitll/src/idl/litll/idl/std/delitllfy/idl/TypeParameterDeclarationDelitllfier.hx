package litll.idl.std.delitllfy.idl;
import litll.core.Litll;
import litll.core.ds.Result;
import litll.idl.delitllfy.DelitllfyArrayContext;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.std.data.idl.TypeParameterDeclaration;
import litll.idl.std.delitllfy.idl.TypeNameDelitllfier;
import litll.idl.std.delitllfy.idl.TypeParameterDeclarationDelitllfier;
using litll.core.ds.ResultTools;

class TypeParameterDeclarationDelitllfier
{
	public static function process(context:DelitllfyContext):Result<TypeParameterDeclaration, DelitllfyError> 
	{
		var expected = ["primitive", "parameterized"];
		return switch (context.litll)
		{
			case Litll.Arr(array) if (array.data.length == 2):
                var arrayContext = new DelitllfyArrayContext(array, 0, context.config);
                var name = arrayContext.read(TypeDependenceNameDelitllfier.process).getOrThrow();
                var type = arrayContext.read(TypeReferenceDelitllfier.process).getOrThrow();
				Result.Ok(TypeParameterDeclaration.Dependence(name, type));
				
			case Litll.Str(data):
                var name = TypeNameDelitllfier.process(context).getOrThrow();
                Result.Ok(TypeParameterDeclaration.TypeName(name));
                
			case data:
				Result.Err(DelitllfyError.ofLitll(context.litll, DelitllfyErrorKind.UnmatchedEnumConstructor(expected)));
		}
	}
}
