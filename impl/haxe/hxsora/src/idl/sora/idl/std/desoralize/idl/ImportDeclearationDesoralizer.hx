package sora.idl.std.desoralize.idl;
import sora.core.Sora;
import sora.idl.desoralize.DesoralizeArrayContext;
import sora.idl.desoralize.DesoralizeContext;
import sora.idl.desoralize.DesoralizeError;
import sora.idl.desoralize.DesoralizeErrorKind;
import sora.core.ds.Result;
import sora.idl.std.data.idl.ImportDeclaration;
using sora.core.ds.ResultTools;

class ImportDeclearationDesoralizer
{
	public static function process(context:DesoralizeContext):Result<ImportDeclaration, DesoralizeError> 
	{
		var expected = ["[import]"];
		return switch (context.sora)
		{
			case Sora.Arr(array) if (array.data.length > 0):
				switch (array.data[0])
				{
					case Sora.Str(string):
						switch (string.data)
						{
							case "import":
								var arrayContext = new DesoralizeArrayContext(context, array, 1);
								var file = arrayContext.read(FilePathDesoralizer.process).getOrThrow();
								arrayContext.close(ImportDeclaration.Import.bind(file));	
								
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