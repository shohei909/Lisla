package litll.idl.std.delitllfy.idl;
import haxe.ds.Option;
import litll.core.Litll;
import litll.core.LitllArray;
import litll.idl.delitllfy.LitllArrayContext;
import litll.idl.delitllfy.LitllConfig;
import litll.idl.delitllfy.LitllContext;
import litll.idl.delitllfy.LitllError;
import litll.idl.delitllfy.LitllErrorKind;
import litll.idl.delitllfy.Litllfier;
import litll.core.ds.Result;
import litll.idl.std.data.idl.Idl;
using litll.core.ds.ResultTools;

class IdlLitllfier
{
	public static function run(litll:LitllArray, ?config:LitllConfig):Result<Idl, LitllError>
	{
		return Litllfier.run(IdlLitllfier.process, litll, config);
	}
	
	public static function process(context:LitllContext):Result<Idl, LitllError> 
	{
		return switch (context.litll)
		{
			case Litll.Str(string):
				Result.Err(LitllError.ofString(string, Option.None, LitllErrorKind.CantBeString));
				
			case Litll.Arr(array):
				try
				{
					var arrayContext = new LitllArrayContext(context, array, 0);
					var headerTags = null; // arrayContext.readRest(HeaderTagLitllfier.process).getOrThrow();
					var packageDeclearations = arrayContext.read(PackageDeclarationLitllfier.process).getOrThrow(); 
					var importDeclearations = arrayContext.readRest(ImportDeclearationLitllfier.process).getOrThrow();
					var typeDefinitions = arrayContext.readRest(TypeDefinitionLitllfier.process).getOrThrow();
					arrayContext.close(Idl.new.bind(headerTags, packageDeclearations, importDeclearations, typeDefinitions));
				}
				catch (error:LitllError)
				{
					Result.Err(error);
				}
		}
	}
}
