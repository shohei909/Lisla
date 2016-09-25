package litll.idl.std.delitllfy.idl;
import litll.core.Litll;
import litll.idl.delitllfy.DelitllfyArrayContext;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.delitllfy.DelitllfyErrorKind;
import litll.core.ds.Result;
import litll.idl.std.data.idl.ImportDeclaration;
using litll.core.ds.ResultTools;

class ImportDeclearationDelitllfier
{
	public static function process(context:DelitllfyContext):Result<ImportDeclaration, DelitllfyError> 
	{
		var expected = ["[import]"];
		return switch (context.litll)
		{
			case Litll.Arr(array) if (array.data.length > 0):
				switch (array.data[0])
				{
					case Litll.Str(string):
						switch (string.data)
						{
							case "import":
								var arrayContext = new DelitllfyArrayContext(context, array, 1);
								var file = arrayContext.read(FilePathDelitllfier.process).getOrThrow();
								arrayContext.close(ImportDeclaration.Import.bind(file));	
								
							case data:
								Result.Err(DelitllfyError.ofArray(array, 0, DelitllfyErrorKind.UnmatchedEnumConstructor("[" + data + "]", expected), []));
						}
						
					case Litll.Arr(_):
						Result.Err(DelitllfyError.ofArray(array, 0, DelitllfyErrorKind.UnmatchedEnumConstructor("[[..]]", expected), []));
				}
				
			case Litll.Arr(_):
				Result.Err(DelitllfyError.ofLitll(context.litll, DelitllfyErrorKind.UnmatchedEnumConstructor("[]", expected)));
				
			case Litll.Str(data):
				Result.Err(DelitllfyError.ofLitll(context.litll, DelitllfyErrorKind.UnmatchedEnumConstructor(data.data, expected)));
		}
	}	
}