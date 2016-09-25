package litll.idl.std.delitllfy.idl;
import litll.idl.delitllfy.DelitllfyArrayContext;
import litll.idl.delitllfy.DelitllfyErrorKind;
import litll.idl.std.data.idl.PackageDeclaration;
import litll.core.Litll;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.core.ds.Result;
import litll.idl.std.data.idl.Idl;
using litll.core.ds.ResultTools;

class PackageDeclarationDelitllfier
{
	public static function process(context:DelitllfyContext):Result<PackageDeclaration, DelitllfyError> 
	{
		var expected = ["[package]"];
		return switch (context.litll)
		{
			case Litll.Arr(array) if (array.data.length > 0):
				switch (array.data[0])
				{
					case Litll.Str(string):
						switch (string.data)
						{
							case "package":
								var arrayContext = new DelitllfyArrayContext(context, array, 1);
								var directory = arrayContext.read(DirectoryPathDelitllfier.process).getOrThrow();
								arrayContext.close(PackageDeclaration.Package.bind(directory));	
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
