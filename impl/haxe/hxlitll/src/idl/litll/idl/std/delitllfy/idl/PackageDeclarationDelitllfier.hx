package litll.idl.std.delitllfy.idl;
import litll.idl.delitllfy.LitllArrayContext;
import litll.idl.delitllfy.LitllErrorKind;
import litll.idl.std.data.idl.PackageDeclaration;
import litll.core.Litll;
import litll.idl.delitllfy.LitllContext;
import litll.idl.delitllfy.LitllError;
import litll.core.ds.Result;
import litll.idl.std.data.idl.Idl;
using litll.core.ds.ResultTools;

class PackageDeclarationLitllfier
{
	public static function process(context:LitllContext):Result<PackageDeclaration, LitllError> 
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
								var arrayContext = new LitllArrayContext(context, array, 1);
								var directory = arrayContext.read(DirectoryPathLitllfier.process).getOrThrow();
								arrayContext.close(PackageDeclaration.Package.bind(directory));	
							case data:
								Result.Err(LitllError.ofArray(array, 0, LitllErrorKind.UnmatchedEnumConstructor("[" + data + "]", expected), []));
						}
						
					case Litll.Arr(_):
						Result.Err(LitllError.ofArray(array, 0, LitllErrorKind.UnmatchedEnumConstructor("[[..]]", expected), []));
				}
				
			case Litll.Arr(_):
				Result.Err(LitllError.ofLitll(context.litll, LitllErrorKind.UnmatchedEnumConstructor("[]", expected)));
				
			case Litll.Str(data):
				Result.Err(LitllError.ofLitll(context.litll, LitllErrorKind.UnmatchedEnumConstructor(data.data, expected)));
		}
	}
}
