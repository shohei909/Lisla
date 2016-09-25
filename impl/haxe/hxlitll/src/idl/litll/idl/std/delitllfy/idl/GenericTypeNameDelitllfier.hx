package litll.idl.std.delitllfy.idl;
import haxe.ds.Option;
import litll.core.Litll;
import litll.idl.delitllfy.LitllArrayContext;
import litll.idl.delitllfy.LitllContext;
import litll.idl.delitllfy.LitllError;
import litll.idl.delitllfy.LitllErrorKind;
import litll.core.ds.Result;
import litll.idl.std.data.idl.GenericTypeName;
using litll.core.ds.ResultTools;

class GenericTypeNameLitllfier
{
	public static function process(context:LitllContext):Result<GenericTypeName, LitllError> 
	{
		return switch (context.litll)
		{
			case Litll.Str(string):
				Result.Err(LitllError.ofString(string, Option.None, LitllErrorKind.CantBeString));
				
			case Litll.Arr(array):
				try
				{
					var arrayContext = new LitllArrayContext(context, array, 0);
					var name = arrayContext.read(TypeNameLitllfier.process).getOrThrow();
					var parameters = arrayContext.readRest(TypeParameterDeclarationLitllfier.process).getOrThrow();
					arrayContext.close(GenericTypeName.new.bind(name, parameters));
				}
				catch (error:LitllError)
				{
					Result.Err(error);
				}
		}
	}
}