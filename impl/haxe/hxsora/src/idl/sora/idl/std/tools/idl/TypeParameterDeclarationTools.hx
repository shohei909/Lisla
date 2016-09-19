package sora.idl.std.tools.idl;
import haxe.macro.Expr.ComplexType;
import haxe.macro.Expr.FunctionArg;
import haxe.macro.Expr.TypeParamDecl;
import sora.idl.std.data.idl.TypeParameterDeclaration;
import sora.idl.std.data.idl.project.DataOutputConfig;

class TypeParameterDeclarationTools
{
	public static function toHaxeParams(params:Array<TypeParameterDeclaration>):Array<TypeParamDecl> 
	{
		var result:Array<TypeParamDecl>  = [];
		for (param in params)
		{
			switch (param)
			{
				case TypeParameterDeclaration.Dependence(_):
					// nothing to do.
					
				case TypeParameterDeclaration.TypeName(typeName):
					result.push(
						{
							name: typeName.toString(),
						}
					);
			}
		}
		return result;
	}	
	
	public static function toHaxeDependences(params:Array<TypeParameterDeclaration>, config:DataOutputConfig):Array<FunctionArg>
	{
		var result:Array<FunctionArg>  = [];
		for (param in params)
		{
			switch (param)
			{
				case TypeParameterDeclaration.Dependence(dependence):
					result.push(
						{
							name: dependence.name.toString(),
							type: ComplexType.TPath(TypeReferenceTools.toHaxeTypePath(dependence.type, config)),
						}
					);
					
				case TypeParameterDeclaration.TypeName(typeName):
					// nothing to do.
			}
		}
		return result;
	}
}
