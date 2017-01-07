package litll.idl.std.tools.idl;
import haxe.ds.Option;
import haxe.macro.Expr.ComplexType;
import haxe.macro.Expr.TypeParam;
import litll.idl.exception.IdlException;
import litll.idl.project.output.IdlToHaxeConvertContext;
import litll.idl.project.output.data.HaxeDataTypePath;
import litll.idl.std.data.idl.GenericTypeReference;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.data.idl.TypeReferenceParameterKind;
import litll.idl.std.data.idl.haxe.DataOutputConfig;

class TypeReferenceTools
{
	public static function toMacroTypePath(reference:TypeReference, config:DataOutputConfig):haxe.macro.Expr.TypePath
	{
		inline function toHaxeDataPath(typePath:TypePath):HaxeDataTypePath
		{
			return config.toHaxeDataPath(typePath);
		}
		
		return switch (reference)
		{
			case TypeReference.Primitive(typePath):
				toHaxeDataPath(typePath).toMacroPath();
				
			case TypeReference.Generic(generic):
				var result = toHaxeDataPath(generic.typePath).toMacroPath();
				
				for (parameter in generic.parameters)
				{
					switch (parameter.processedValue.getOrThrow(IdlException.new.bind("Type reference " + generic.typePath.toString() + " must be processed")))
					{
						case TypeReferenceParameterKind.Type(type):
							result.params.push(TypeParam.TPType(ComplexType.TPath(toMacroTypePath(type, config))));
						
						case TypeReferenceParameterKind.Dependence(_):
					}
				}
				
				result;
		}
	}
	
	public static function generalize(type:TypeReference):GenericTypeReference
	{
		return switch (type)
		{
			case TypeReference.Primitive(primitive):
				new GenericTypeReference(primitive, []);
				
			case TypeReference.Generic(generic):
				generic;
		}
	}
}
