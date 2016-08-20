package sora.idl.std.desoralize.idl;
import haxe.ds.Option;
import sora.core.Sora;
import sora.core.SoraArray;
import sora.idl.desoralize.DesoralizeArrayContext;
import sora.idl.desoralize.DesoralizeConfig;
import sora.idl.desoralize.DesoralizeContext;
import sora.idl.desoralize.DesoralizeError;
import sora.idl.desoralize.DesoralizeErrorKind;
import sora.idl.desoralize.Desoralizer;
import sora.core.ds.Result;
import sora.idl.std.data.idl.Idl;
using sora.core.ds.ResultTools;

class IdlDesoralizer
{
	public static function run(sora:SoraArray, ?config:DesoralizeConfig):Result<Idl, DesoralizeError>
	{
		return Desoralizer.run(IdlDesoralizer.process, sora, config);
	}
	
	public static function process(context:DesoralizeContext):Result<Idl, DesoralizeError> 
	{
		return switch (context.sora)
		{
			case Sora.Str(string):
				Result.Err(DesoralizeError.ofString(string, Option.None, DesoralizeErrorKind.CantBeString));
				
			case Sora.Arr(array):
				try
				{
					var arrayContext = new DesoralizeArrayContext(context, array, 0);
					var headerTags = null; // arrayContext.readRest(HeaderTagDesoralizer.process).getOrThrow();
					var packageDeclearations = arrayContext.read(PackageDeclarationDesoralizer.process).getOrThrow(); //
					var importDeclearations = arrayContext.readRest(ImportDeclearationDesoralizer.process).getOrThrow();
					var typeDefinitions = arrayContext.readRest(TypeDefinitionDesoralizer.process).getOrThrow();
					arrayContext.close(Idl.new.bind(headerTags, packageDeclearations, importDeclearations, typeDefinitions));
				}
				catch (error:DesoralizeError)
				{
					Result.Err(error);
				}
		}
	}
}
