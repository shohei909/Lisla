package sora.idl.std.desoralize.idl;
import sora.idl.desoralize.DesoralizeArrayContext;
import sora.idl.desoralize.DesoralizeErrorKind;
import sora.idl.std.data.idl.PackageDeclaration;
import sora.core.Sora;
import sora.idl.desoralize.DesoralizeContext;
import sora.idl.desoralize.DesoralizeError;
import sora.core.ds.Result;
import sora.idl.std.data.idl.Idl;
using sora.core.ds.ResultTools;

class PackageDeclarationDesoralizer
{
	public static function process(context:DesoralizeContext):Result<PackageDeclaration, DesoralizeError> 
	{
		var expected = ["[package]"];
		return switch (context.sora)
		{
			case Sora.Arr(array) if (array.data.length > 0):
				switch (array.data[0])
				{
					case Sora.Str(string):
						switch (string.data)
						{
							case "package":
								var arrayContext = new DesoralizeArrayContext(context, array, 1);
								var directory = arrayContext.read(DirectoryPathDesoralizer.process).getOrThrow();
								arrayContext.close(PackageDeclaration.Package.bind(directory));	
							case data:
								Result.Err(DesoralizeError.ofArray(array, 0, DesoralizeErrorKind.UnmatchedEnumConstructor("[" + data + "]", expected), []));
						}
						
					case Sora.Arr(_):
						Result.Err(DesoralizeError.ofArray(array, 0, DesoralizeErrorKind.UnmatchedEnumConstructor("[[..]]", expected), []));
				}
				
			case Sora.Arr(_):
				Result.Err(DesoralizeError.ofSora(context.sora, DesoralizeErrorKind.UnmatchedEnumConstructor("[]", expected)));
				
			case Sora.Str(data):
				Result.Err(DesoralizeError.ofSora(context.sora, DesoralizeErrorKind.UnmatchedEnumConstructor(data.data, expected)));
		}
	}
}
