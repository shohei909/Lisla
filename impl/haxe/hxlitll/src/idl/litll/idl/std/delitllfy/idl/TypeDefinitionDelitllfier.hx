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
import litll.idl.std.delitllfy.idl.TupleElementDelitllfier;
import litll.idl.std.delitllfy.idl.TypeDefinitionDelitllfier;
import litll.idl.std.delitllfy.idl.TypeNameDeclarationDelitllfier;
import litll.idl.std.delitllfy.idl.TypeReferenceDelitllfier;
using litll.core.ds.ResultTools;

class TypeDefinitionDelitllfier
{
	public static function process(context:DelitllfyContext):Result<TypeDefinition, DelitllfyError> 
	{
		var expected = ["[newtype]", "[tuple]", "[enum]"];
		return switch (context.litll)
		{
			case Litll.Arr(array) if (array.data.length > 0):
				switch (array.data[0])
				{
					case Litll.Str(string):
						switch (string.data)
						{
							case "newtype":
								var arrayContext = new DelitllfyArrayContext(array, 1, context.config);
								var name = arrayContext.read(TypeNameDeclarationDelitllfier.process).getOrThrow();
								var type = arrayContext.read(TypeReferenceDelitllfier.process).getOrThrow();
								arrayContext.close(TypeDefinition.Newtype.bind(name, type));	
							
							case "tuple":
								var arrayContext = new DelitllfyArrayContext(array, 1, context.config);
								var name = arrayContext.read(TypeNameDeclarationDelitllfier.process).getOrThrow();
								var type = arrayContext.readRest(TupleElementDelitllfier.process).getOrThrow();
								arrayContext.close(TypeDefinition.Tuple.bind(name, type));	
							
							case "enum":
								var arrayContext = new DelitllfyArrayContext(array, 1, context.config);
								var name = arrayContext.read(TypeNameDeclarationDelitllfier.process).getOrThrow();
								var constructors = arrayContext.readRest(EnumConstructorDelitllfier.process).getOrThrow();
								arrayContext.close(TypeDefinition.Enum.bind(name, constructors));	
														
							case data:
								Result.Err(DelitllfyError.ofArray(array, 0, DelitllfyErrorKind.UnmatchedEnumConstructor(expected), []));
						}
						
					case Litll.Arr(_):
						Result.Err(DelitllfyError.ofArray(array, 0, DelitllfyErrorKind.UnmatchedEnumConstructor(expected), []));
				}
				
			case data:
				Result.Err(DelitllfyError.ofLitll(context.litll, DelitllfyErrorKind.UnmatchedEnumConstructor(expected)));
		}
	}
}