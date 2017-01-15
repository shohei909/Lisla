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
				
			case TypeReference.Generic(typePath, parameters):
				var result = toHaxeDataPath(typePath).toMacroPath();
				
				for (parameter in parameters)
				{
					switch (parameter.processedValue.getOrThrow(IdlException.new.bind("Type reference " + typePath.toString() + " must be processed")))
					{
						case TypeReferenceParameterKind.Type(type):
							result.params.push(TypeParam.TPType(ComplexType.TPath(toMacroTypePath(type, config))));
						
						case TypeReferenceParameterKind.Dependence(_):
					}
				}
				
				result;
		}
	}
    
	public static function getTypePath(type:TypeReference):TypePath
    {
		return switch (type)
		{
			case TypeReference.Primitive(primitive):
				primitive;
				
			case TypeReference.Generic(typePath, _):
    			typePath;
		}
    }
    
	public static function generalize(type:TypeReference):GenericTypeReference
	{
		return switch (type)
		{
			case TypeReference.Primitive(primitive):
				new GenericTypeReference(primitive, []);
				
			case TypeReference.Generic(name, parameters):
    			new GenericTypeReference(name, parameters);
		}
	}
    
    public static function getName(type:TypeReference):String
    {
		return switch (type)
		{
			case TypeReference.Primitive(primitive):
				primitive.toString();
				
			case TypeReference.Generic(typePath, _):
    			typePath.toString();
		}
    }
}
