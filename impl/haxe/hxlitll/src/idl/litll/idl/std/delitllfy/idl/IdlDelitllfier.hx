package litll.idl.std.delitllfy.idl;
import haxe.ds.Option;
import litll.core.Litll;
import litll.core.LitllArray;
import litll.core.ds.Maybe;
import litll.idl.delitllfy.DelitllfyArrayContext;
import litll.idl.delitllfy.DelitllfyConfig;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.delitllfy.DelitllfyErrorKind;
import litll.idl.delitllfy.Delitllfier;
import litll.core.ds.Result;
import litll.idl.std.data.idl.Idl;
import litll.idl.std.delitllfy.idl.IdlDelitllfier;
import litll.idl.std.delitllfy.idl.PackageDeclarationDelitllfier;
import litll.idl.std.delitllfy.idl.TypeDefinitionDelitllfier;
using litll.core.ds.ResultTools;

class IdlDelitllfier
{
	public static function run(litll:LitllArray<Litll>, config:DelitllfyConfig = null):Result<Idl, DelitllfyError>
	{
        if (config == null) config = new DelitllfyConfig();
		return Delitllfier.run(IdlDelitllfier.process, litll, config);
	}
	
	public static function process(context:DelitllfyContext):Result<Idl, DelitllfyError> 
	{
		return switch (context.litll)
		{
			case Litll.Str(string):
				Result.Err(DelitllfyError.ofString(string, Maybe.none(), DelitllfyErrorKind.CantBeString));
				
			case Litll.Arr(array):
				try
				{
					var arrayContext = new DelitllfyArrayContext(array, 0, context.config);
					var headerTags = null; // arrayContext.readRest(HeaderTagDelitllfier.process).getOrThrow();
					var packageDeclearations = arrayContext.read(PackageDeclarationDelitllfier.process).getOrThrow(); 
					var importDeclearations = arrayContext.readRest(ImportDeclearationDelitllfier.process).getOrThrow();
					var typeDefinitions = arrayContext.readRest(TypeDefinitionDelitllfier.process).getOrThrow();
					arrayContext.close(Idl.new.bind(headerTags, packageDeclearations, importDeclearations, typeDefinitions));
				}
				catch (error:DelitllfyError)
				{
					Result.Err(error);
				}
		}
	}
}