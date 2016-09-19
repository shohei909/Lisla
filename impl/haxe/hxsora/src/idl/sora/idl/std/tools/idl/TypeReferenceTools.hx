package sora.idl.std.tools.idl;
import haxe.macro.Expr.ComplexType;
import haxe.macro.Expr.TypeParam;
import sora.idl.std.data.idl.TypeReference;
import sora.idl.std.data.idl.project.DataOutputConfig;

class TypeReferenceTools
{
	public static function toHaxeTypePath(reference:TypeReference, config:DataOutputConfig):haxe.macro.Expr.TypePath
	{
		return switch (reference)
		{
			case TypeReference.Primitive(typePath):
				config.applyFilters(typePath).toHaxeTypePath();
				
			case TypeReference.Generic(generic):
				var result = config.applyFilters(generic.typePath).toHaxeTypePath();
				for (parameter in generic.parameters)
				{
					result.params.push(TypeParam.TPType(ComplexType.TPath(toHaxeTypePath(parameter, config))));
				}
				result;
		}
	}	
}
