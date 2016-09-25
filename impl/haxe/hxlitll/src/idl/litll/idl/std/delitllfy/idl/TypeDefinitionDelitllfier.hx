package litll.idl.std.delitllfy.idl;
import litll.core.Litll;
import litll.idl.delitllfy.LitllArrayContext;
import litll.idl.delitllfy.LitllContext;
import litll.idl.delitllfy.LitllError;
import litll.idl.delitllfy.LitllErrorKind;
import litll.core.ds.Result;
import litll.idl.std.data.idl.TypeDefinition;
using litll.core.ds.ResultTools;

class TypeDefinitionLitllfier
{
	public static function process(context:LitllContext):Result<TypeDefinition, LitllError> 
	{
		var expected = ["[alias]", "[tuple]", "[enum]", "[union]"];
		return switch (context.litll)
		{
			case Litll.Arr(array) if (array.data.length > 0):
				switch (array.data[0])
				{
					case Litll.Str(string):
						switch (string.data)
						{
							case "alias":
								var arrayContext = new LitllArrayContext(context, array, 1);
								var name = arrayContext.read(TypeNameDeclarationLitllfier.process).getOrThrow();
								var type = arrayContext.read(TypeReferenceLitllfier.process).getOrThrow();
								arrayContext.close(TypeDefinition.Alias.bind(name, type));	
							
							case "tuple":
								var arrayContext = new LitllArrayContext(context, array, 1);
								var name = arrayContext.read(TypeNameDeclarationLitllfier.process).getOrThrow();
								var type = arrayContext.readRest(ArgumentLitllfier.process).getOrThrow();
								arrayContext.close(TypeDefinition.Tuple.bind(name, type));	
							
							case "enum":
								var arrayContext = new LitllArrayContext(context, array, 1);
								var name = arrayContext.read(TypeNameDeclarationLitllfier.process).getOrThrow();
								var constructors = arrayContext.readRest(EnumConstructorLitllfier.process).getOrThrow();
								arrayContext.close(TypeDefinition.Enum.bind(name, constructors));	
							
							case "union":
								var arrayContext = new LitllArrayContext(context, array, 1);
								var name = arrayContext.read(TypeNameDeclarationLitllfier.process).getOrThrow();
								var elements = arrayContext.readRest(UnionConstructorLitllfier.process).getOrThrow();
								arrayContext.close(TypeDefinition.Union.bind(name, elements));	
							
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