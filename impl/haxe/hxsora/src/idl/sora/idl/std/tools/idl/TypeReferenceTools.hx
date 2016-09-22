package sora.idl.std.tools.idl;
import haxe.macro.Expr.ComplexType;
import haxe.macro.Expr.TypeParam;
import sora.idl.std.data.idl.TypePath;
import sora.idl.std.data.idl.TypeReference;
import sora.idl.std.data.idl.project.DataOutputConfig;

class TypeReferenceTools
{
	public static function toMacroTypePath(reference:TypeReference, config:DataOutputConfig):haxe.macro.Expr.TypePath
	{
		return switch (reference)
		{
			case TypeReference.Primitive(typePath):
				config.toHaxeDataPath(typePath).toMacroPath();
				
			case TypeReference.Generic(generic):
				var result = config.toHaxeDataPath(generic.typePath).toMacroPath();
				for (parameter in generic.parameters)
				{
					result.params.push(TypeParam.TPType(ComplexType.TPath(toMacroTypePath(parameter, config))));
				}
				result;
		}
	}
}
