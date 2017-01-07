package litll.idl.std.delitllfy.idl;
import haxe.ds.Option;
import litll.core.Litll;
import litll.core.ds.Maybe;
import litll.core.ds.Result;
import litll.idl.delitllfy.DelitllfyArrayContext;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.delitllfy.DelitllfyErrorKind;
import litll.idl.std.data.idl.TypeDependenceDeclaration;
import litll.idl.std.delitllfy.idl.TypeDependenceDeclarationDelitllfier;
import litll.idl.std.delitllfy.idl.TypeDependenceNameDelitllfier;
import litll.idl.std.delitllfy.idl.TypeReferenceDelitllfier;
using litll.core.ds.ResultTools;

class TypeDependenceDeclarationDelitllfier
{
	public static function process(context:DelitllfyContext):Result<TypeDependenceDeclaration, DelitllfyError> 
	{
		return switch (context.litll)
		{
			case Litll.Str(string):
				Result.Err(DelitllfyError.ofString(string, Maybe.none(), DelitllfyErrorKind.CantBeString));
				
			case Litll.Arr(array):
				try
				{
					var arrayContext = new DelitllfyArrayContext(array, 0, context.config);
					var name = arrayContext.read(TypeDependenceNameDelitllfier.process).getOrThrow();
					var type = arrayContext.read(TypeReferenceDelitllfier.process).getOrThrow();
					arrayContext.close(TypeDependenceDeclaration.new.bind(name, type));
				}
				catch (error:DelitllfyError)
				{
					Result.Err(error);
				}
		}
	}	
}
