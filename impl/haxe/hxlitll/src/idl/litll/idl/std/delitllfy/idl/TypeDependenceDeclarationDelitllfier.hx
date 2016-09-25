package litll.idl.std.delitllfy.idl;
import haxe.ds.Option;
import litll.core.Litll;
import litll.core.ds.Result;
import litll.idl.delitllfy.LitllArrayContext;
import litll.idl.delitllfy.LitllContext;
import litll.idl.delitllfy.LitllError;
import litll.idl.delitllfy.LitllErrorKind;
import litll.idl.std.data.idl.TypeDependenceDeclaration;
using litll.core.ds.ResultTools;

class TypeDependenceDeclarationLitllfier
{
	public static function process(context:LitllContext):Result<TypeDependenceDeclaration, LitllError> 
	{
		return switch (context.litll)
		{
			case Litll.Str(string):
				Result.Err(LitllError.ofString(string, Option.None, LitllErrorKind.CantBeString));
				
			case Litll.Arr(array):
				try
				{
					var arrayContext = new LitllArrayContext(context, array, 0);
					var name = arrayContext.read(TypeDependenceNameLitllfier.process).getOrThrow();
					var type = arrayContext.read(TypeReferenceLitllfier.process).getOrThrow();
					arrayContext.close(TypeDependenceDeclaration.new.bind(name, type));
				}
				catch (error:LitllError)
				{
					Result.Err(error);
				}
		}
	}	
}
