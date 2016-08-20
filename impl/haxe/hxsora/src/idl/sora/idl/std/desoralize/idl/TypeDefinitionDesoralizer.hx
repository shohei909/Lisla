package sora.idl.std.desoralize.idl;
import sora.core.Sora;
import sora.idl.desoralize.DesoralizeArrayContext;
import sora.idl.desoralize.DesoralizeContext;
import sora.idl.desoralize.DesoralizeError;
import sora.idl.desoralize.DesoralizeErrorKind;
import sora.core.ds.Result;
import sora.idl.std.data.idl.TypeDefinition;
using sora.core.ds.ResultTools;

class TypeDefinitionDesoralizer
{
	public static function process(context:DesoralizeContext):Result<TypeDefinition, DesoralizeError> 
	{
		var expected = ["[alias]", "[tuple]", "[enum]", "[union]"];
		return switch (context.sora)
		{
			case Sora.Arr(array) if (array.data.length > 0):
				switch (array.data[0])
				{
					case Sora.Str(string):
						switch (string.data)
						{
							case "alias":
								var arrayContext = new DesoralizeArrayContext(context, array, 1);
								var name = arrayContext.read(TypeNameDeclarationDesoralizer.process).getOrThrow();
								var type = arrayContext.read(TypeReferenceDesoralizer.process).getOrThrow();
								arrayContext.close(TypeDefinition.Alias.bind(name, type));	
							
							case "tuple":
								var arrayContext = new DesoralizeArrayContext(context, array, 1);
								var name = arrayContext.read(TypeNameDeclarationDesoralizer.process).getOrThrow();
								var type = arrayContext.readRest(ArgumentDesoralizer.process).getOrThrow();
								arrayContext.close(TypeDefinition.Tuple.bind(name, type));	
							
							case "enum":
								var arrayContext = new DesoralizeArrayContext(context, array, 1);
								var name = arrayContext.read(TypeNameDeclarationDesoralizer.process).getOrThrow();
								var constructors = arrayContext.readRest(EnumConstructorDesoralizer.process).getOrThrow();
								arrayContext.close(TypeDefinition.Enum.bind(name, constructors));	
							
							case "union":
								var arrayContext = new DesoralizeArrayContext(context, array, 1);
								var name = arrayContext.read(TypeNameDeclarationDesoralizer.process).getOrThrow();
								var elements = arrayContext.readRest(UnionElementDesoralizer.process).getOrThrow();
								arrayContext.close(TypeDefinition.Union.bind(name, elements));	
							
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