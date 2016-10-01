package litll.idl.std.delitllfy.idl;
import litll.core.Litll;
import litll.idl.delitllfy.DelitllfyArrayContext;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.delitllfy.DelitllfyErrorKind;
import litll.core.ds.Result;
import litll.idl.std.data.idl.TypeDefinition;
import litll.idl.std.delitllfy.idl.ArgumentDelitllfier;
import litll.idl.std.delitllfy.idl.EnumConstructorDelitllfier;
import litll.idl.std.delitllfy.idl.TypeDefinitionDelitllfier;
import litll.idl.std.delitllfy.idl.TypeNameDeclarationDelitllfier;
import litll.idl.std.delitllfy.idl.TypeReferenceDelitllfier;
import litll.idl.std.delitllfy.idl.UnionConstructorDelitllfier;
using litll.core.ds.ResultTools;

class TypeDefinitionDelitllfier
{
	public static function process(context:DelitllfyContext):Result<TypeDefinition, DelitllfyError> 
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
								var arrayContext = new DelitllfyArrayContext(context, array, 1);
								var name = arrayContext.read(TypeNameDeclarationDelitllfier.process).getOrThrow();
								var type = arrayContext.read(TypeReferenceDelitllfier.process).getOrThrow();
								arrayContext.close(TypeDefinition.Alias.bind(name, type));	
							
							case "tuple":
								var arrayContext = new DelitllfyArrayContext(context, array, 1);
								var name = arrayContext.read(TypeNameDeclarationDelitllfier.process).getOrThrow();
								var type = arrayContext.readRest(ArgumentDelitllfier.process).getOrThrow();
								arrayContext.close(TypeDefinition.Tuple.bind(name, type));	
							
							case "enum":
								var arrayContext = new DelitllfyArrayContext(context, array, 1);
								var name = arrayContext.read(TypeNameDeclarationDelitllfier.process).getOrThrow();
								var constructors = arrayContext.readRest(EnumConstructorDelitllfier.process).getOrThrow();
								arrayContext.close(TypeDefinition.Enum.bind(name, constructors));	
							
							case "union":
								var arrayContext = new DelitllfyArrayContext(context, array, 1);
								var name = arrayContext.read(TypeNameDeclarationDelitllfier.process).getOrThrow();
								var elements = arrayContext.readRest(UnionConstructorDelitllfier.process).getOrThrow();
								arrayContext.close(TypeDefinition.Union.bind(name, elements));	
							
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